"""Import MIT-licensed Forever training data, without the standalone addon engine."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def import_data(source):
    source = Path(source)
    toc = next(source.glob('*.toc')).read_text(encoding='utf-8-sig')
    version = re.search(r'^## Version:\s*(\S+)', toc, re.M).group(1)
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
    recipes = source / 'Crafting/Recipes/Camelot'
    if not recipes.is_dir():
        recipes = source / 'Crafting/Recipes'
    files += sorted(recipes.glob('*.lua'))
    if len(files) < 20:
        raise ValueError('Incomplete Forever class/recipe data')
    manifest = ['<Ui xmlns="http://www.blizzard.com/wow/ui/">']
    for path in files:
        relative = path.relative_to(source)
        if path.parent == recipes:
            relative = Path('Crafting/Recipes') / path.name
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        text = path.read_text(encoding='utf-8-sig')
        header = f"-- Adapted from What's Training? {version} (MIT); see LICENSE.txt and NOTICE.md.\n"
        # Supply a private data namespace, preserving the source tables and order.
        text = header + 'local _, FT = ...\nlocal tinsert = table.insert\nlocal function LoadData(...)\n' + text + '\nend\nLoadData("ForeverTools", FT.trainingData)\n'
        target.write_text(text, encoding='utf-8', newline='\n')
        manifest.append(f'  <Script file="{relative.as_posix()}"/>')
    manifest.append('</Ui>')
    (destination / 'Manifest.xml').write_text('\n'.join(manifest) + '\n', encoding='utf-8', newline='\n')
    (destination / 'NOTICE.md').write_text(
        "# What's Training? data\n\n"
        f"Source: What's Training? {version}, author Fusionpit / Sveng.\n"
        "Project: https://www.curseforge.com/wow/addons/whats-training\n\n"
        "MIT license and original copyright notice are preserved in LICENSE.txt.\n"
        "Imported: Forever/Camelot class, quest, pet, weapon, faction and recipe data.\n"
        "Changes: private ForeverTools data namespace; no external addon engine, UI or libraries.\n"
        "Realm-specific spell IDs and requirements reflect this source version.\n",
        encoding='utf-8', newline='\n')
    print(f'Imported {len(files)} training data files')


if __name__ == '__main__':
    import_data(sys.argv[1])
