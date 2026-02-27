#!/bin/bash
# ============================================================
# Russian Phonetic Max - Keyboard Layout Installer
# For German QWERTZ Apple Keyboards (ISO)
# ============================================================

BUNDLE_NAME="Russian-Phonetic-Max.bundle"
KEYLAYOUT_NAME="Russian-Phonetic-Max.keylayout"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLE_SRC="$SCRIPT_DIR/$BUNDLE_NAME"
KEYLAYOUT_SRC="$SCRIPT_DIR/$KEYLAYOUT_NAME"
SYS_KB_DIR="/Library/Keyboard Layouts"
USR_KB_DIR="$HOME/Library/Keyboard Layouts"

echo ""
echo "=== Russian Phonetic Max - Installer ==="
echo ""

# Check bundle exists
if [ ! -d "$BUNDLE_SRC" ]; then
    echo "FEHLER: $BUNDLE_NAME nicht gefunden in $SCRIPT_DIR"
    exit 1
fi

# ── [1/7] Sync keylayout source → bundle ─────────────────────────────────────
echo "[1/7] Keylayout-Quelle in Bundle synchronisieren..."
BUNDLE_RES="$BUNDLE_SRC/Contents/Resources/$KEYLAYOUT_NAME"
if [ -f "$KEYLAYOUT_SRC" ]; then
    cp "$KEYLAYOUT_SRC" "$BUNDLE_RES"
    echo "   Kopiert: $KEYLAYOUT_NAME → bundle/Contents/Resources/"
else
    echo "   Uebersprungen (Quelldatei nicht gefunden, bundle-Version wird genutzt)"
fi

# ── [2/7] Remove ALL old Russian layouts (user) ──────────────────────────────
echo "[2/7] Alte User-Layouts entfernen..."
rm -rf "$USR_KB_DIR/Russian-Phonetic-Max.bundle"      2>/dev/null || true
rm -f  "$USR_KB_DIR/Russian-Phonetic-Max.keylayout"   2>/dev/null || true
rm -f  "$USR_KB_DIR/Russian-MB.keylayout"             2>/dev/null || true
rm -f  "$USR_KB_DIR/Russian-MB.keylayout.disabled"    2>/dev/null || true
rm -rf "$USR_KB_DIR/Russian Keyboard MB.bundle"       2>/dev/null || true
echo "   Erledigt."

# ── [3/7] Remove ALL old Russian layouts (system, via osascript sudo) ────────
echo "[3/7] Alte System-Layouts entfernen (Admin-Passwort noetig)..."
osascript -e "do shell script \"
    rm -rf '$SYS_KB_DIR/Russian-Phonetic-Max.bundle'    2>/dev/null
    rm -f  '$SYS_KB_DIR/Russian-Phonetic-Max.keylayout' 2>/dev/null
    rm -f  '$SYS_KB_DIR/Russian-MB.keylayout'           2>/dev/null
    rm -rf '$SYS_KB_DIR/Russian Keyboard MB.bundle'     2>/dev/null
    echo done
\" with administrator privileges"
echo "   Erledigt."

# ── [4/7] Install bundle + permissions + remove quarantine ───────────────────
echo "[4/7] Bundle system-weit installieren..."
osascript -e "do shell script \"
    cp -R '$BUNDLE_SRC' '$SYS_KB_DIR/'
    chmod 755 '$SYS_KB_DIR/$BUNDLE_NAME'
    chmod 755 '$SYS_KB_DIR/$BUNDLE_NAME/Contents'
    chmod 755 '$SYS_KB_DIR/$BUNDLE_NAME/Contents/Resources'
    chmod 644 '$SYS_KB_DIR/$BUNDLE_NAME/Contents/Info.plist'
    chmod 644 '$SYS_KB_DIR/$BUNDLE_NAME/Contents/Resources/$KEYLAYOUT_NAME'
    xattr -cr '$SYS_KB_DIR/$BUNDLE_NAME'
    echo done
\" with administrator privileges"
echo "   $BUNDLE_NAME → $SYS_KB_DIR/ (Quarantaene entfernt)"

# ── [5/7] Clear HIToolbox cache ───────────────────────────────────────────────
echo "[5/7] HIToolbox-Cache leeren..."
defaults delete com.apple.HIToolbox AppleEnabledInputSources  2>/dev/null || true
defaults delete com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null || true
defaults delete com.apple.HIToolbox AppleInputSourceHistory   2>/dev/null || true
echo "   Erledigt."

# ── [6/7] Clear com.apple.inputsources.plist ─────────────────────────────────
echo "[6/7] com.apple.inputsources.plist bereinigen..."
/usr/libexec/PlistBuddy -c "Delete :AppleSelectedInputSources" \
    ~/Library/Preferences/com.apple.inputsources.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :AppleEnabledInputSources" \
    ~/Library/Preferences/com.apple.inputsources.plist 2>/dev/null || true
echo "   Erledigt."

# ── [7/7] Clear IntlDataCache ────────────────────────────────────────────────
echo "[7/7] IntlDataCache leeren..."
osascript -e "do shell script \"find /var/folders -name 'com.apple.IntlDataCache*' -delete 2>/dev/null; echo done\" with administrator privileges" 2>/dev/null || true
echo "   Erledigt."

# ── Verification ──────────────────────────────────────────────────────────────
echo ""
INSTALLED_BUNDLE="$SYS_KB_DIR/$BUNDLE_NAME/Contents/Resources/$KEYLAYOUT_NAME"
if [ -f "$INSTALLED_BUNDLE" ]; then
    echo "Installierte Dateien vorhanden: JA  ✓"
else
    echo "Installierte Datei vorhanden: NEIN  ✗  (Installation moeglicherweise fehlgeschlagen)"
fi

# ── Required next steps ───────────────────────────────────────────────────────
echo ""
echo "=== ERFORDERLICHE NAECHSTE SCHRITTE ==="
echo ""
echo "  1. Systemeinstellungen → Tastatur → Eingabequellen"
echo "     → Alle vorhandenen Russisch-Layouts ENTFERNEN (auch 'Russian - Phonetic')"
echo ""
echo "  2. Mac NEU STARTEN  (nicht nur abmelden – vollstaendiger Neustart!)"
echo ""
echo "  3. Nach dem Neustart:"
echo "     Systemeinstellungen → Tastatur → Eingabequellen → '+'"
echo "     → Russisch → 'Russian - Phonetic - Max' hinzufuegen"
echo ""
echo "  4. Test:"
echo "     Y → ы    Z → з    ISO-Taste (links neben 1) → ё"
echo ""
echo "=== Fertig! ==="
echo ""
