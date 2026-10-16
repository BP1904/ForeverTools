"""Build the install catalog for the single ForeverTools addon bundle."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def build():
    addons = json.loads((ROOT / 'addons.json').read_text(encoding='utf-8'))
    if len(addons) != 1 or addons[0]['folder'] != 'ForeverTools':
        raise ValueError('All features must ship inside the single ForeverTools folder')
    catalog = {'schema': 1, 'addons': []}
    for addon in addons:
        folder = ROOT / addon['folder']
        assert (folder / (folder.name + '.toc')).is_file(), folder
        files = [{'path': p.relative_to(folder).as_posix(),
                  'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                 for p in sorted(folder.rglob('*')) if p.is_file()]
        catalog['addons'].append(dict(addon, files=files))
    (ROOT / 'catalog.json').write_text(json.dumps(catalog, indent=2, ensure_ascii=False) + '\n', encoding='utf-8', newline='\n')


if __name__ == '__main__':
    build()
