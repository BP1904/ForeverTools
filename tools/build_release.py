"""Create the player ZIP with ForeverTools directly at the archive root."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile
from build_catalog import ROOT, build


def release(output=None):
    build()
    output = Path(output) if output else ROOT / '.tools/releases/ForeverTools.zip'
    output.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(output, 'w', compression=ZIP_DEFLATED) as archive:
        for file in sorted((ROOT / 'ForeverTools').rglob('*')):
            if file.is_file():
                archive.write(file, file.relative_to(ROOT).as_posix())
    return output


if __name__ == '__main__':
    print(release())
