#!/bin/bash
# React AppImage Build Script - Agentic Dev Velocity
set -e

VERSION=${1:-1.0.0}
PACKAGE_NAME="react-template"

echo "Building React AppImage..."

# Create AppDir
rm -rf AppDir
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/scalable/apps

# Copy build files
cp -r dist/* AppDir/usr/share/${PACKAGE_NAME}/

# Create launcher script
cat > AppDir/usr/bin/${PACKAGE_NAME} <<'EOF'
#!/bin/bash
# React Template Launcher
APP_DIR="/usr/share/react-template"
cd "$APP_DIR"
exec python3 -m http.server 8080
EOF
chmod +x AppDir/usr/bin/${PACKAGE_NAME}

# Create desktop entry
cat > AppDir/usr/share/applications/${PACKAGE_NAME}.desktop <<'EOF'
[Desktop Entry]
Name=React Template
Comment=React application with fast agent loop
Exec=react-template
Icon=react-template
Terminal=true
Type=Application
Categories=Development;
EOF

# Create icon
cat > AppDir/usr/share/icons/hicolor/scalable/apps/${PACKAGE_NAME}.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#61dafb" stroke-width="2">
  <circle cx="12" cy="12" r="10"/>
  <path d="M12 6v6l4 2"/>
</svg>
EOF

# Build AppImage if appimagetool exists
if [ -f appimagetool-x86_64.AppImage ]; then
    chmod +x appimagetool-x86_64.AppImage
    ./appimagetool-x86_64.AppImage --appimage-extract-and-run AppDir ${PACKAGE_NAME}-${VERSION}-x86_64.AppImage
    echo "AppImage created: ${PACKAGE_NAME}-${VERSION}-x86_64.AppImage"
else
    echo "Note: appimagetool not found. AppDir created but not packaged."
    echo "Download from: https://github.com/AppImage/AppImageKit/releases"
fi

echo "=== React AppImage Build Complete ==="
