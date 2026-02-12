#!/usr/bin/env bash
# Build Python AppImage - use with: mise run build-appimage
# TARGET: < 30s

set -e
VERSION="${1:-1.0.0}"
OUTPUT="python-boilerplate-${VERSION}-x86_64.AppImage"
VENV_DIR="${VENV_DIR:-.venv}"

# PyInstaller on Linux needs objdump (binutils)
if [ "$(uname -s)" = "Linux" ] && ! command -v objdump &>/dev/null; then
  echo "ERROR: objdump is required (PyInstaller). Install binutils, e.g.: apt install binutils" >&2
  exit 1
fi

echo "=== Building AppImage ($OUTPUT) ==="
START=$(date +%s.%N)

# Remove broken venv so uv can recreate (e.g. after symlink or path issues)
if [ -d "$VENV_DIR" ] && [ ! -x "$VENV_DIR/bin/python" ] && [ ! -x "$VENV_DIR/bin/python3" ]; then
  rm -rf "$VENV_DIR"
fi

# Use /tmp for uv venv when project dir may not allow symlinks (e.g. shared/media drives)
if command -v uv &>/dev/null; then
  export UV_PROJECT_ENVIRONMENT="${UV_PROJECT_ENVIRONMENT:-/tmp/venv-python-appimage-$$}"
  uv run --with pyinstaller pyinstaller --onefile --name python-boilerplate --paths src src/app/main.py
else
  if [ -d "$VENV_DIR" ] && [ -f "$VENV_DIR/bin/activate" ]; then
    . "$VENV_DIR/bin/activate"
    pip install -q pyinstaller
  else
    python3 -m pip install --user -q pyinstaller 2>/dev/null || python3 -m pip install -q pyinstaller
  fi
  pyinstaller --onefile --name python-boilerplate --paths src src/app/main.py
fi

# AppDir (binary + desktop in root + AppRun; appimagetool requires .desktop at AppDir root)
mkdir -p AppDir/usr/bin AppDir/usr/share/applications
cp dist/python-boilerplate AppDir/usr/bin/
cat > AppDir/AppRun <<'APPRUN'
#!/bin/sh
exec "$(dirname "$0")/usr/bin/python-boilerplate" "$@"
APPRUN
chmod +x AppDir/AppRun
cat > AppDir/python-boilerplate.desktop <<'DESKTOP'
[Desktop Entry]
Name=Python Boilerplate
Comment=Python application with fast agent loop
Exec=python-boilerplate
Icon=python-boilerplate
Terminal=true
Type=Application
Categories=Development;
DESKTOP
cp AppDir/python-boilerplate.desktop AppDir/usr/share/applications/
# Placeholder icon so appimagetool doesn't error (Icon= in desktop)
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\x0f\x00\x00\x01\x01\x00\x05\x18\xd8N\x00\x00\x00\x00IEND\xaeB`\x82' > AppDir/python-boilerplate.png

# appimagetool (run from /tmp so it works when project dir is noexec)
if [ ! -f appimagetool-x86_64.AppImage ]; then
  wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool-x86_64.AppImage
fi
# Run appimagetool from /tmp so symlinks (e.g. .DirIcon) work when project dir is noexec/nosymlink
APPIMAGETOOL="/tmp/appimagetool-$$.AppImage"
APPDIR_TMP="/tmp/AppDir-$$"
cp appimagetool-x86_64.AppImage "$APPIMAGETOOL"
chmod +x "$APPIMAGETOOL"
cp -r AppDir "$APPDIR_TMP"
chmod +x "$APPDIR_TMP/AppRun" "$APPDIR_TMP/usr/bin/python-boilerplate" 2>/dev/null || true
ARCH=x86_64 "$APPIMAGETOOL" --appimage-extract-and-run "$APPDIR_TMP" "$OUTPUT"
rm -f "$APPIMAGETOOL"
rm -rf "$APPDIR_TMP"

END=$(date +%s.%N)
echo "=== Built: $OUTPUT ($(echo "$END - $START" | bc)s) ==="
