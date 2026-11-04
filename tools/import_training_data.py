"""Import MIT-licensed Forever training data, without the standalone addon engine."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]


def import_data(source):
    source = Path(source)
    destination = ROOT / 'ForeverTools/Data/Training'
    destination.mkdir(parents=True, exist_ok=True)
    license_text = (source / 'LICENSE').read_text(encoding='utf-8')
    if 'MIT License' not in license_text:
        raise ValueError('Expected MIT license; review licensing before importing')
    (destination / 'LICENSE.txt').write_text(license_text, encoding='utf-8', newline='\n')
    files = sorted((source / 'Classes/Camelot').glob('*.lua'))
    weapon_override = source / 'Classes/Camelot/WeaponSkills.lua'
    files.remove(weapon_override)
    files += [source / 'Classes/WeaponSkills.lua', weapon_override]
    files += sorted((source / 'Crafting/Recipes').glob('*.lua'))
    manifest = ['<Ui xmlns="http://www.blizzard.com/wow/ui/">']
    for path in files:
        relative = path.relative_to(source)
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        text = path.read_text(encoding='utf-8-sig')
        header = '-- Adapted from What\'s Training? 11.0.0-beta25 (MIT); see LICENSE.txt and NOTICE.md.\n'
        # Supply a private data namespace, preserving the source tables and order.
        text = header + 'local _, FT = ...\nlocal tinsert = table.insert\nlocal function LoadData(...)\n' + text + '\nend\nLoadData("ForeverTools", FT.trainingData)\n'
        target.write_text(text, encoding='utf-8', newline='\n')
        manifest.append(f'  <Script file="{relative.as_posix()}"/>')
    manifest.append('</Ui>')
    (destination / 'Manifest.xml').write_text('\n'.join(manifest) + '\n', encoding='utf-8', newline='\n')
    (destination / 'NOTICE.md').write_text(
        "# What's Training? data\n\n"
        "Source: locally installed What's Training? 11.0.0-beta25, author Sveng.\n"
        "Project: https://www.curseforge.com/wow/addons/whats-training\n\n"
        "MIT license and original copyright notice are preserved in LICENSE.txt.\n"
        "Imported: Forever/Camelot class, quest, pet, weapon, faction and recipe data.\n"
        "Changes: private ForeverTools data namespace; no external addon engine, UI or libraries.\n"
        "Realm-specific spell IDs and requirements reflect this source version.\n",
        encoding='utf-8', newline='\n')
    print(f'Imported {len(files)} training data files')


if __name__ == '__main__':
    import_data(sys.argv[1])
