"""Adapt the installed BigWigs and Nova locally; retain upstream rights notices.

Game-specific TOC entries are resolved for Camelot (Forever). Application chunks
are registered, then executed by the embedded loader with their own addon table.
No original addon directory is needed at runtime.
"""
from pathlib import Path
import json
import re
import shutil
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
NS = 'http://www.blizzard.com/wow/ui/'
LOCALES = ('deDE', 'esES', 'esMX', 'frFR', 'itIT', 'koKR', 'ptBR', 'ruRU', 'zhCN', 'zhTW')


def lua(value):
    if isinstance(value, dict):
        return '{' + ','.join('[' + lua(k) + ']=' + lua(v) for k, v in value.items()) + '}'
    if isinstance(value, list):
        return '{' + ','.join(map(lua, value)) + '}'
    if isinstance(value, bool):
        return 'true' if value else 'false'
    return json.dumps(value, ensure_ascii=False)


def game_entry(line):
    for mode, values in re.findall(r'\[(AllowLoadGameType|ExcludeLoadGameType) ([^]]+)\]', line):
        games = set(re.split(r',\s*', values))
        matches = bool(games & {'camelot', 'classic'})
        if (mode == 'AllowLoadGameType' and not matches) or (mode == 'ExcludeLoadGameType' and matches):
            return []
    path = line.split(' [')[0].replace('\\', '/').replace('[Game]', 'Camelot')
    if '[TextLocale]' in path:
        return [path.replace('[TextLocale]', loc) for loc in LOCALES]
    return [path]


def build(source):
    source = Path(source)
    for feature, folders in (
        ('BigWigs', sorted(p for p in source.glob('BigWigs*') if p.is_dir())),
        ('NovaInstanceTracker', [source / 'NovaInstanceTracker']),
    ):
        target = ROOT / 'ForeverTools/Features' / feature
        target.mkdir(parents=True, exist_ok=True)
        packages = []
        libraries, manifest = [], []
        source_count = 0
        paths = {p.name: 'Interface\\AddOns\\ForeverTools\\Features\\' + feature + '\\' + p.name + '\\'
                 for p in folders}

        def assets(text):
            for name, replacement in paths.items():
                text = text.replace('Interface\\\\AddOns\\\\' + name + '\\\\', replacement.replace('\\', '\\\\'))
                text = text.replace('Interface\\AddOns\\' + name + '\\', replacement)
            return text

        def application(path, package):
            nonlocal source_count
            relative = path.relative_to(source)
            out = target / relative
            out.parent.mkdir(parents=True, exist_ok=True)
            code = assets(path.read_text(encoding='utf-8-sig'))
            if feature == 'NovaInstanceTracker':
                # AceAddon/AceLocale/AceConfig names and AceDB's global store are distinct.
                code = code.replace('"NovaInstanceTracker"', '"FTNovaInstanceTracker"')
                code = code.replace('"NITdatabase"', '"ForeverToolsNovaDB"')
                code = code.replace('function NIT:OnInitialize()', 'function NIT:FTInitialize()')
            else:
                for old, new in {'BigWigs3DB': 'ForeverToolsBigWigsDB',
                                 'BigWigsIconDB': 'ForeverToolsBigWigsIconDB',
                                 'BigWigsStatsDB': 'ForeverToolsBigWigsStatsDB'}.items():
                    code = re.sub(r'\b' + old + r'\b', new, code)
            code = code.replace('getfenv(0)', 'getfenv(1)')
            # Each source remains its own chunk (including legal top-level returns).
            wrapped = ('-- Local adaptation; see ../NOTICE.txt.\nlocal _, FT = ...\n'
                       'local function Component(...)\n' + code + '\nend\n'
                       'FT.embedded.' + feature + ':Add(' + lua(package) + ', Component, ' + lua(relative.as_posix()) + ')\n')
            out.write_text(wrapped, encoding='utf-8', newline='\n')
            manifest.append('  <Script file="' + relative.as_posix() + '"/>')
            source_count += 1

        def visit(path, package, library=False):
            if not path.is_file():
                raise FileNotFoundError(path)
            relative = path.relative_to(source)
            if path.suffix.lower() == '.lua':
                if library and path.name != 'AceGUIWidget-BigWigsSharedDropdown.lua':
                    libraries.append('  <Script file="' + relative.as_posix() + '"/>')
                else:
                    application(path, package)
                return
            if path.suffix.lower() != '.xml':
                raise ValueError(path)
            text = path.read_text(encoding='utf-8-sig')
            text = re.sub(r'\s+xsi:schemaLocation="[^"]*"', '', text)
            root = ET.fromstring(text)
            # Library XML may contain templates or scripts; retain it verbatim.
            if library:
                libraries.append('  <Include file="' + relative.as_posix() + '"/>')
                return
            for node in list(root):
                ref = node.attrib.get('file')
                if node.tag.rsplit('}', 1)[-1] in ('Script', 'Include') and ref:
                    visit(path.parent / ref.replace('\\', '/'), package, '/Lib' in ref or ref.startswith(('Lib', 'lib')))
                else:
                    templates.append(node)

        templates = []
        for folder in folders:
            # Keep media, libraries, copyright notices and translations with their sources.
            shutil.copytree(folder, target / folder.name, dirs_exist_ok=True,
                            ignore=shutil.ignore_patterns('tests', '.tools', '.git', '__pycache__'))
            for excluded in (target / folder.name).rglob('tests'):
                if excluded.is_dir() and excluded.resolve().is_relative_to(target.resolve()):
                    shutil.rmtree(excluded)
            for out in (target / folder.name).rglob('*'):
                if out.is_file() and out.suffix.lower() in ('.xml', '.lua'):
                    text = assets(out.read_text(encoding='utf-8-sig'))
                    # The original NIT embeds uses Include for Lua files.
                    if out.suffix.lower() == '.xml':
                        text = re.sub(r'<Include(\s+file="[^"]+\.lua"\s*/>)', r'<Script\1', text)
                    out.write_text(text, encoding='utf-8', newline='\n')
            toc = (folder / (folder.name + '.toc')).read_text(encoding='utf-8-sig')
            metadata = {}
            files = []
            for line in toc.splitlines():
                line = line.strip()
                if line.startswith('## ') and ': ' in line:
                    key, value = line[3:].split(': ', 1)
                    metadata[key] = value
                elif line and not line.startswith('#'):
                    files.extend(game_entry(line))
            packages.append({'name': folder.name, 'meta': metadata,
                             'deps': [x.strip() for x in metadata.get('Dependencies', '').split(',') if x.strip()],
                             'lod': metadata.get('LoadOnDemand') == '1'})
            for filename in files:
                path = folder / filename
                if '[TextLocale]' not in filename and not path.exists():
                    raise FileNotFoundError(path)
                visit(path, folder.name, filename.startswith(('Libs/', 'Lib/')))

        (target / 'Registry.lua').write_text(
            'local _, FT = ...\nFT.embedded.' + feature + ' = FT:NewEmbeddedRuntime(' + lua(feature) + ', ' + lua(packages) + ')\n', encoding='utf-8')
        header = '<Ui xmlns="' + NS + '">\n'
        # NIT's UI templates must be available before its deferred application chunks.
        template_xml = '\n'.join(ET.tostring(t, encoding='unicode') for t in templates)
        (target / 'Libraries.xml').write_text(header + '\n'.join(dict.fromkeys(libraries)) + '\n' + template_xml + '\n</Ui>\n', encoding='utf-8')
        (target / 'Manifest.xml').write_text(header + '  <Include file="Libraries.xml"/>\n  <Script file="Registry.lua"/>\n' + '\n'.join(manifest) + '\n</Ui>\n', encoding='utf-8')
        (target / 'NOTICE.txt').write_text(
            feature + ': local adaptation of user-installed sources for WoW Forever.\n'
            + ('BigWigs v427.8. Authors: Funkeh, Nebula, Justwait, Delk.\n'
               'All Rights Reserved. Upstream: https://github.com/BigWigsMods/BigWigs\n'
               'Original TOC: You are free to fork and modify on GitHub; ask authors about other uses.\n'
               if feature == 'BigWigs' else
               'Nova Instance Tracker 2.31. Author: Novaspark-Arugal OCE.\n'
               'Upstream: https://www.curseforge.com/wow/addons/nova-instance-tracker\n')
            + 'Original copyright and library licenses retained in the copied files.\n'
            'Changes: deferred internal package loading, private API environment, bundled asset paths,\n'
            'separate saved variables, migration, ForeverTools module controls and commands.\n'
            'This local integration grants no additional redistribution rights.\n', encoding='utf-8')
        print(feature, len(packages), 'packages,', source_count, 'application chunks')


if __name__ == '__main__':
    build(sys.argv[1])
