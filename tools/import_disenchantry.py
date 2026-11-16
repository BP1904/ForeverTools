"""Embed the MIT Disenchantry engine; ForeverTools supplies lifecycle and launcher."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def import_addon(source):
    source = Path(source)
    toc = (source/'Disenchantry.toc').read_text(encoding='utf-8-sig')
    version = re.search(r'^## Version:\s*(\S+)', toc, re.M).group(1)
    target = ROOT / 'ForeverTools/Features/Disenchantry'
    target.mkdir(parents=True, exist_ok=True)
    license_text = (source / 'LICENSE').read_text(encoding='utf-8')
    if 'MIT License' not in license_text:
        raise ValueError('Review licensing before importing')
    for name in ('LICENSE', 'NOTICE'):
        (target / (name + '.txt')).write_text((source/name).read_text(encoding='utf-8'), encoding='utf-8', newline='\n')
    manifest=['<Ui xmlns="http://www.blizzard.com/wow/ui/">']
    count=0
    for line in (source/'Disenchantry.toc').read_text(encoding='utf-8').splitlines():
        path=line.strip().replace('\\','/')
        if not path.endswith('.lua') or path.startswith('Libs/') or path in ('Disenchantry.lua','UI/Launcher.lua'):
            continue
        # Retain our compact layout, secure Escape/close and combat drag guards.
        if path in ('UI/Compact.lua','UI/Modes.lua','UI/Widgets.lua','UI/Windows.lua') and (target/path).exists():
            manifest.append(f'  <Script file="{path}"/>'); count+=1
            continue
        text=(source/path).read_text(encoding='utf-8-sig')
        text=text.replace('DisenchantryDB','ForeverToolsDisenchantryDB')
        text=text.replace('DisenchantryCharacterDB','ForeverToolsDisenchantryCharacterDB')
        text=text.replace('Disenchantry_','ForeverToolsDisenchantry_')
        text=text.replace('disenchantryResults','foreverToolsDisenchantryResults')
        if path=='Locales.lua':
            text=text.replace('Requires TSM or Auctionator.', 'Uses ForeverTools scan prices; TSM and Auctionator are optional.')
            text=text.replace('Benötigt TSM oder Auctionator.', 'Verwendet ForeverTools-Scanpreise; TSM und Auctionator sind optional.')
            text=text.replace('Нужен TSM или Auctionator.', 'Используются цены сканирования ForeverTools; TSM и Auctionator необязательны.')
        if path=='UI/Settings.lua':
            start=text.index('    controls.minimap = UI.Check(')
            end=text.index('    App.settingsMaterialsButton', start)
            text=text[:start]+text[end:]
            text=text.replace('        controls.minimap:SetChecked(not App.db.minimap.hide)\n','')
        if path=='DisenchantResults.lua':
            text=text.replace('function ns.DisenchantResults.AddTooltip(item, tooltip)\n',
                              'function ns.DisenchantResults.AddTooltip(item, tooltip)\n    if not ns.IsEnabled() then return end\n')
            text=text.replace('    local function enhance(tooltip, data, explicitRef)\n',
                              '    local function enhance(tooltip, data, explicitRef)\n        if not ns.IsEnabled() then return end\n')
        if path=='Core/Runtime.lua':
            text += '\nlocal build = GetBuildInfo and GetBuildInfo()\nif type(build)=="string" and build:match("^1%.60%.") then App.IS_NON_RETAIL_CLIENT=true end\n'
        if path=='Statistics.lua':
            text += '\nfunction Stats.CancelProcessing() target=nil; pending=nil end\n'
        if path=='UI/Auction.lua':
            text=text.replace('"DisenchantryAuctionTab"','"ForeverToolsDisenchantryAuctionTab"')
            text=text.replace('local function create()\n', 'local function create()\n    if not ns.IsEnabled() then return end\n    if ns.ftAuctionTab then ns.ftAuctionTab:Show() end\n')
            text=text.replace('        tab:SetText("Disenchantry")', '        ns.ftAuctionTab = tab\n        tab:SetText("Disenchantry")')
            text=text.replace('events:SetScript("OnEvent", function(_, event, ...)\n', 'events:SetScript("OnEvent", function(_, event, ...)\n    if not ns.IsEnabled() then return end\n')
            text=text.replace('events:SetScript("OnUpdate", function(_, delta)\n', 'events:SetScript("OnUpdate", function(_, delta)\n    if not ns.IsEnabled() or (not Buy.active and not Scan.running) then return end\n')
            text += '\nfunction ns.StopAuction()\n    Scan.Stop(); Buy.Cancel()\n    if panel then panel:Hide() end\n    if ns.ftAuctionTab then ns.ftAuctionTab:Hide() end\nend\n'
        if path in ('Core/AuctionScan.lua','Core/AuctionPurchase.lua'):
            text=re.sub(r'(function (?:Scan.Start|Buy.Prepare|Buy.Confirm)\([^\n]*\)\n)', r'\1    if not ns.IsEnabled() then return end\n', text)
        header=f"-- Embedded from Disenchantry {version} (MIT); see LICENSE.txt and NOTICE.txt.\n"
        wrapped=header+'local _, FT = ...\nlocal GetLocale = GetLocale or function() return "deDE" end\nlocal function LoadComponent(...)\n'+text+'\nend\nLoadComponent("ForeverTools", FT.disenchantry)\n'
        output=target/path; output.parent.mkdir(parents=True,exist_ok=True)
        output.write_text(wrapped,encoding='utf-8',newline='\n')
        manifest.append(f'  <Script file="{path}"/>'); count+=1
    manifest.append('</Ui>')
    (target/'Manifest.xml').write_text('\n'.join(manifest)+'\n',encoding='utf-8',newline='\n')
    (target/'Integration.md').write_text(
        '# Disenchantry in ForeverTools\n\n'
        f'Embedded source: Disenchantry {version}, x_Raven_x, with original Rakuga attribution. MIT.\n'
        'The original LICENSE and NOTICE are preserved alongside this file.\n\n'
        'Changes: private namespace, saved-variable/frame/tooltip names; common ForeverTools menu;\n'
        'no bundled launcher libraries; optional icon controlled in the common menu; lazy UI lifecycle and module gate;\n'
        'Forever client recognition; cancellation of pending statistics on disable.\n'
        'The ForeverTools module supplies migration, price-cache integration and additional click validation.\n'
        'Reimport with tools/import_disenchantry.py and the original addon path.\n',encoding='utf-8',newline='\n')
    print(f'Embedded {count} Disenchantry files')


if __name__=='__main__':
    import_addon(sys.argv[1])
