#!/bin/bash
# ============================================================
# Russian Phonetic Max - .pkg Builder
# Builds a macOS Installer package (.pkg) - no sudo required.
# Admin rights are only needed when the user runs the .pkg.
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/build"
OUTPUT_DIR="$SCRIPT_DIR/output"

BUNDLE_NAME="Russian-Phonetic-Max.bundle"
KEYLAYOUT_NAME="Russian-Phonetic-Max.keylayout"
PKG_IDENTIFIER="org.sil.ukelele.keyboardlayout.russian-phonetic-max"
PKG_VERSION="1.2"
FINAL_PKG_NAME="Russian-Phonetic-Max-Installer.pkg"

echo ""
echo "=== Russian Phonetic Max - Package Builder ==="
echo ""

# ── [1/6] Clean build directories ────────────────────────────────────────────
echo "[1/6] Build-Verzeichnisse bereinigen..."
rm -rf "$BUILD_DIR"
rm -rf "$OUTPUT_DIR"
mkdir -p "$BUILD_DIR/payload/Library/Keyboard Layouts"
mkdir -p "$BUILD_DIR/component"
mkdir -p "$OUTPUT_DIR"
echo "   Erledigt."

# ── [2/6] Sync keylayout source → bundle ─────────────────────────────────────
echo "[2/6] Keylayout in Bundle synchronisieren..."
KEYLAYOUT_SRC="$PROJECT_DIR/$KEYLAYOUT_NAME"
BUNDLE_SRC="$PROJECT_DIR/$BUNDLE_NAME"

if [ ! -f "$KEYLAYOUT_SRC" ]; then
    echo "FEHLER: $KEYLAYOUT_NAME nicht gefunden in $PROJECT_DIR"
    exit 1
fi
if [ ! -d "$BUNDLE_SRC" ]; then
    echo "FEHLER: $BUNDLE_NAME nicht gefunden in $PROJECT_DIR"
    exit 1
fi

cp "$KEYLAYOUT_SRC" "$BUNDLE_SRC/Contents/Resources/$KEYLAYOUT_NAME"
echo "   Synchronisiert: $KEYLAYOUT_NAME -> Bundle"

# ── [3/6] Stage payload ──────────────────────────────────────────────────────
echo "[3/6] Payload zusammenstellen..."
PAYLOAD_KB="$BUILD_DIR/payload/Library/Keyboard Layouts"

# Copy bundle (COPYFILE_DISABLE prevents AppleDouble ._* files in archives)
COPYFILE_DISABLE=1 cp -R "$BUNDLE_SRC" "$PAYLOAD_KB/$BUNDLE_NAME"

# Set correct permissions in payload
chmod 755 "$PAYLOAD_KB/$BUNDLE_NAME"
chmod 755 "$PAYLOAD_KB/$BUNDLE_NAME/Contents"
chmod 755 "$PAYLOAD_KB/$BUNDLE_NAME/Contents/Resources"
find "$PAYLOAD_KB/$BUNDLE_NAME" -type f -exec chmod 644 {} +

# Remove quarantine attributes, .DS_Store, and AppleDouble (._*) files
xattr -cr "$PAYLOAD_KB" 2>/dev/null || true
find "$PAYLOAD_KB" -name ".DS_Store" -delete 2>/dev/null || true
find "$PAYLOAD_KB" -name "._*" -delete 2>/dev/null || true
dot_clean "$PAYLOAD_KB" 2>/dev/null || true

echo "   Bundle bereit."

# ── [4/6] Build component package ────────────────────────────────────────────
echo "[4/6] Component Package erstellen (pkgbuild)..."
COMPONENT_PKG="$BUILD_DIR/component/russian-phonetic-max.pkg"

# Final xattr strip right before packaging (macOS 26 com.apple.provenance)
find "$BUILD_DIR/payload" -exec xattr -c {} \; 2>/dev/null || true

COPYFILE_DISABLE=1 pkgbuild \
    --root "$BUILD_DIR/payload" \
    --identifier "$PKG_IDENTIFIER" \
    --version "$PKG_VERSION" \
    --ownership recommended \
    --scripts "$SCRIPT_DIR/scripts" \
    "$COMPONENT_PKG"

echo "   Component: $COMPONENT_PKG"

# ── [5/6] Build final installer package ──────────────────────────────────────
echo "[5/6] Installer Package erstellen (productbuild)..."
FINAL_PKG="$OUTPUT_DIR/$FINAL_PKG_NAME"

productbuild \
    --distribution "$SCRIPT_DIR/distribution.xml" \
    --resources "$SCRIPT_DIR/resources" \
    --package-path "$BUILD_DIR/component" \
    "$FINAL_PKG"

echo "   Installer: $FINAL_PKG"

# ── [6/6] Summary ────────────────────────────────────────────────────────────
echo ""
echo "[6/6] Fertig!"
echo ""
PKG_SIZE=$(du -h "$FINAL_PKG" | cut -f1)
echo "   Ausgabe:  $FINAL_PKG"
echo "   Groesse:  $PKG_SIZE"
echo ""
echo "Zum Installieren:"
echo "   open \"$FINAL_PKG\""
echo ""
