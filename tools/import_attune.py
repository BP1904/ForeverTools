"""Adapt the user's installed Attune Forever into the local ForeverTools bundle.
Original copyright is retained; this does not grant redistribution rights.
"""
from pathlib import Path
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]

def build(source):
    source = Path(source)
    target = ROOT / 'ForeverTools/Features/Attune'
    target.mkdir(parents=True, exist_ok=True)
    for folder in ('Libs', 'Images'):
        shutil.copytree(source / folder, target / folder, dirs_exist_ok=True)
    embeds = (source/'embeds.xml').read_text(encoding='utf-8-sig')
    embeds = re.sub(r'<Include( file="[^"]+\.lua"/>)', r'<Script\1', embeds)
    (target/'embeds.xml').write_text(embeds, encoding='utf-8')
    paths = ['Locales/' + p.name for p in sorted((source/'Locales').glob('*.lua'))]
    # AceLocale needs the English fallback before other languages.
    paths.remove('Locales/enUS.lua')
    paths.insert(0, 'Locales/enUS.lua')
    paths += ['Attune.lua', 'AttuneData.lua', 'AttuneQuestGivers.lua',
              'AttuneClassQuests.lua', 'AttuneQuestRewards.lua']
    manifest = ['<Ui xmlns="http://www.blizzard.com/wow/ui/">',
                '  <Include file="embeds.xml"/>', '  <Script file="Bootstrap.lua"/>']
    for path in paths:
        code = (source/path).read_text(encoding='utf-8-sig')
        code = re.sub(r'\bAttune(?=[A-Z_]|\b)', 'FTAttune', code)
        code = re.sub(r'\bTreeExpandStatus\b', 'FTAttuneTreeExpandStatus', code)
        code = code.replace('Interface\\\\AddOns\\\\FTAttune\\\\',
                            'Interface\\\\AddOns\\\\ForeverTools\\\\Features\\\\Attune\\\\')
        # Keep the wire format and upstream version compatible with other Attune users.
        for suffix in ('Channel', 'Version', 'Sync'):
            code = code.replace('"FTAttune_' + suffix + '"', '"Attune_' + suffix + '"')
        code = code.replace('getfenv(0)', 'getfenv(1)')
        code = re.sub(r'(?<![\w/])/attune\b', '/ftattune', code)
        if path == 'Attune.lua':
            code = code.replace('SetTitle("  FTAttune")', 'SetTitle("  ForeverTools – Attune")')
            code = code.replace('FTAttune_SetChromeTitle(attunelocal_bronzeChrome, "FTAttune")', 'FTAttune_SetChromeTitle(attunelocal_bronzeChrome, "ForeverTools – Attune")')
            code = code.replace('tostring(GetAddOnMetadata(addonName, "Version"))', '"16001-34"')
            code = code.replace('function FTAttune:OnInitialize()', 'function FTAttune:FTRegisterOptions()')
            code = code.replace('function FTAttune:OnEnable()', 'function FTAttune:FTStart()')
            code = code.replace('SlashCmdList["FTAttune"] = FTAttune_SlashCommandHandler', '')
            code = re.sub(r'^SLASH_Attune1 = .*$', '', code, flags=re.M)
            # Existing module launcher is the default; a separate icon remains optional.
            code = code.replace('FTAttune_DB.minimapbuttonpos.hide = false', 'FTAttune_DB.minimapbuttonpos.hide = true')
            code += '''
-- ForeverTools lifecycle. FTStart runs once; toggling never recreates brokers/options.
FTAttune:SetEnabledState(false)
function FTAttune:OnInitialize() self.ftReady = true end
function FTAttune:OnEnable()
    if not ForeverTools.modules.attune:Active() then self:Disable(); return end
    if not self.ftStarted then
        local ok, err = pcall(function()
            self:FTStart()
            self:FTRegisterOptions()
        end)
        if not ok then
            ForeverTools.modules.attune.failed = true
            self:Disable()
            ForeverTools:Print("Attune: " .. tostring(err))
            return
        end
        self.ftStarted = true
    else
        for _, event in ipairs({"CHAT_MSG_ADDON", "PLAYER_LOGOUT", "PLAYER_LEVEL_UP",
            "QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_TURNED_IN", "UPDATE_FACTION",
            "BAG_UPDATE", "GOSSIP_SHOW", "QUEST_DETAIL"}) do self:RegisterEvent(event) end
        if attunelocal_hasCombatLog then cleu_parser:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else cleu_parser:RegisterEvent("PARTY_KILL"); cleu_parser:RegisterEvent("UNIT_DIED") end
        self:RegisterComm(attunelocal_syncprefix)
        FTAttune_CheckProgress()
        self:BAG_UPDATE(nil)
        FTAttune_ForceAttuneTabRefresh()
        if not FTAttune_DB.minimapbuttonpos.hide then attunelocal_minimapicon:Show("FTAttune_Broker") end
    end
end
function FTAttune:OnDisable()
    cleu_parser:UnregisterAllEvents()
    if self.ftStarted then FTAttune_SaveTreeExpandStatus() end
    attuneItemScanQueued = false
    if attunelocal_iconView then attunelocal_iconView.pending = false end
    attunelocal_syncStatus = -1
    FTAttune_CloseQuestGiverMap()
    for _, widget in pairs({main=attunelocal_frame, export=attunelocal_export_frame,
        survey=attunelocal_survey_frame, sync=attunelocal_syncProgressWidget,
        reward=attunelocal_rewardFrame, detail=attunelocal_questDetail}) do
        if widget.Hide then widget:Hide() end
    end
    attunelocal_minimapicon:Hide("FTAttune_Broker")
    LibStub("AceConfigDialog-3.0"):Close("FTAttune")
end
FTAttune.ftSendCommMessage = FTAttune.SendCommMessage
function FTAttune:SendCommMessage(...)
    if ForeverTools.modules.attune:Active() then return self:ftSendCommMessage(...) end
end
'''
        wrapped = ('-- Local Attune adaptation; original copyright retained. See NOTICE.txt.\n'
                   'local _, FT = ...\nlocal function Component(...)\n' + code +
                   '\nend\nsetfenv(Component, FT.attuneEnv)\nComponent(...)\n')
        out = target/path
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(wrapped, encoding='utf-8', newline='\n')
        manifest.append(f'  <Script file="{path}"/>')
    manifest.append('</Ui>')
    (target/'Manifest.xml').write_text('\n'.join(manifest)+'\n', encoding='utf-8')
    (target/'NOTICE.txt').write_text('Attune Forever 16001-34, CixiDelmont / Antoine Desmarets.\n'
        'Copyright (c) 2019-2021 by Antoine Desmarets. All Rights Reserved.\n'
        'Source: user-installed Attune, adapted locally at the user request.\n'
        'https://www.curseforge.com/wow/addons/attune/files/9263982\n'
        'No redistribution license is granted by this integration. Bundled libraries retain their notices.\n'
        'Changes: isolated environment, frame/locale/widget identifiers and asset paths;\n'
        'ForeverTools settings, lifecycle, timer guards, migration and launcher.\n', encoding='utf-8')
    print(f'Adapted {len(paths)} source files')

if __name__ == '__main__':
    build(sys.argv[1])
