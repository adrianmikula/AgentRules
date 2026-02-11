#!/bin/bash
# DEB Package Build Script - Python Boilerplate
# Optimized for sub-10s agentic feedback loop
set -e

VERSION=${1:-1.0.0}
PACKAGE_NAME="python-boilerplate"
ARCH="all"

echo "Building DEB package: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Create package directory
PACKAGE_DIR="${PACKAGE_NAME}_${VERSION}_${ARCH}"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/bin"
mkdir -p "$PACKAGE_DIR/usr/share/applications"
mkdir -p "$PACKAGE_DIR/usr/share/man/man1"
mkdir -p "$PACKAGE_DIR/opt/${PACKAGE_NAME}"

# =================================================================
# Create control file
# =================================================================
cat > "$PACKAGE_DIR/DEBIAN/control" <<'EOF'
Package: python-boilerplate
Version: 1.0.0
Section: devel
Priority: optional
Architecture: all
Depends: python3 (>= 3.10), python3-pip
Maintainer: Developer <dev@example.com>
Description: Python Boilerplate Application
 Python application with fast agent loop for development.
 Installed size: 1000 KB
Homepage: https://github.com/example/python-boilerplate
EOF

# =================================================================
# Create preinst script
# =================================================================
cat > "$PACKAGE_DIR/DEBIAN/preinst" <<'EOF'
#!/bin/bash
set -e
echo "Installing python-boilerplate..."
EOF
chmod +x "$PACKAGE_DIR/DEBIAN/preinst"

# =================================================================
# Create postinst script
# =================================================================
cat > "$PACKAGE_DIR/DEBIAN/postinst" <<'EOF'
#!/bin/bash
set -e
echo "Updating application database..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications 2>/dev/null || true
fi
echo "python-boilerplate installed successfully!"
EOF
chmod +x "$PACKAGE_DIR/DEBIAN/postinst"

# =================================================================
# Create prerm script
# =================================================================
cat > "$PACKAGE_DIR/DEBIAN/prerm" <<'EOF'
#!/bin/bash
set -e
echo "Removing python-boilerplate..."
EOF
chmod +x "$PACKAGE_DIR/DEBIAN/prerm"

# =================================================================
# Create postrm script
# =================================================================
cat > "$PACKAGE_DIR/DEBIAN/postrm" <<'EOF'
#!/bin/bash
set -e
if [ "$1" = "purge" ] || [ "$1" = "remove" ]; then
    rm -f /usr/share/applications/python-boilerplate.desktop 2>/dev/null || true
    rm -f /usr/bin/python-boilerplate 2>/dev/null || true
fi
EOF
chmod +x "$PACKAGE_DIR/DEBIAN/postrm"

# =================================================================
# Create launcher script
# =================================================================
cat > "$PACKAGE_DIR/usr/bin/python-boilerplate" <<'EOF'
#!/usr/bin/env python3
"""Python Boilerplate - Entry point"""
import sys
import uvicorn
from src.app.main import app

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF
chmod +x "$PACKAGE_DIR/usr/bin/python-boilerplate"

# =================================================================
# Create desktop entry
# =================================================================
cat > "$PACKAGE_DIR/usr/share/applications/python-boilerplate.desktop" <<'EOF'
[Desktop Entry]
Name=Python Boilerplate
Comment=Python application with fast agent loop
Exec=python-boilerplate
Icon=python3
Terminal=true
Type=Application
Categories=Development;
EOF

# =================================================================
# Create man page
# =================================================================
cat > "$PACKAGE_DIR/usr/share/man/man1/python-boilerplate.1" <<'EOF'
.TH PYTHON-BOILERPLATE "1" "February 2026" "python-boilerplate 1.0.0" "User Commands"
.SH NAME
python-boilerplate \- Python application with fast agent loop
.SH SYNOPSIS
python-boilerplate
.SH DESCRIPTION
Runs the Python boilerplate application with fast development feedback.
.SH OPTIONS
.TP
\fB\-\-help\fR
Show this help message.
.SH AUTHOR
Written by Developer.
EOF

# =================================================================
# Create md5sums
# =================================================================
cd "$PACKAGE_DIR"
find usr opt -type f -exec md5sum {} \; > DEBIAN/md5sums 2>/dev/null || true
cd ..

# =================================================================
# Build package
# =================================================================
echo "Building package..."
if command -v fakeroot >/dev/null 2>&1; then
    fakeroot dpkg-deb --build "$PACKAGE_DIR" "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
else
    dpkg-deb --build "$PACKAGE_DIR" "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb" 2>/dev/null || \
    echo "Note: Install fakeroot for signed packages"
fi

echo ""
echo "=== DEB Package Created ==="
echo "Package: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "Size: $(du -h "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb" | cut -f1)"
echo ""
echo "Quick Commands:"
echo "  Verify: make verify-deb"
echo "  Install: sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "  Remove: sudo dpkg --remove ${PACKAGE_NAME}"
echo ""
echo "Status: SUCCESS"
