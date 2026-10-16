"""Player download must install by dragging its single root folder into AddOns."""
import hashlib
import json
import sys
import tempfile
import unittest
from pathlib import Path
from zipfile import ZipFile
from test_forevertools import ROOT

sys.path.insert(0, str(ROOT / 'tools'))
from build_release import release


class ReleaseTest(unittest.TestCase):
    def test_ready_to_install_zip_contains_exact_catalog_bytes_and_bundled_updater(self):
        (ROOT / '.tools').mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix='release-test-', dir=ROOT / '.tools') as temp:
            output = release(Path(temp) / 'ForeverTools.zip')
            with ZipFile(output) as archive:
                names = archive.namelist()
                self.assertEqual({name.split('/')[0] for name in names}, {'ForeverTools'})
                self.assertIn('ForeverTools/ForeverTools.toc', names)
                self.assertIn('ForeverTools/Update.cmd', names)
                self.assertIn('ForeverTools/Updater/Update-ForeverTools.ps1', names)
                self.assertFalse(any('/tests/' in n or '/.tools/' in n for n in names))
                catalog = json.loads((ROOT / 'catalog.json').read_text(encoding='utf-8'))
                expected = {'ForeverTools/' + f['path'] for f in catalog['addons'][0]['files']}
                self.assertEqual(set(names), expected)
                for file in catalog['addons'][0]['files']:
                    self.assertEqual(hashlib.sha256(archive.read('ForeverTools/' + file['path'])).hexdigest(), file['sha256'])
                command = archive.read('ForeverTools/Update.cmd').decode('utf-8')
                self.assertIn('-GamePath "%~dp0..\\..\\.."', command)
                self.assertNotIn('-Watch', command)
                self.assertIn('-Background', command)
                self.assertIn('-EnableStartup', command)
