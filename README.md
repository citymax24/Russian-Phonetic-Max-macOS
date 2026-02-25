# Russian Phonetic Max for macOS

A Russian phonetic keyboard layout for macOS, optimized for **German QWERTZ (ISO) keyboards**.

Type Russian intuitively on your German keyboard — every key is where you'd phonetically expect it.

## Features

- **QWERTZ-adapted**: `Y` → ы, `Z` → з (unlike standard QWERTY-based phonetic layouts)
- **ISO key support**: The extra key left of Shift outputs ё
- **All 33 Cyrillic letters** accessible without dead keys
- **Option-layer** for extended characters (Serbian, Ukrainian, Macedonian)
- **Dual install**: System-wide (`/Library/`) + user-level (`~/Library/`) for macOS 26 compatibility
- **Apple Silicon + Intel** (arm64 & x86_64)
- **macOS 12 Monterey** or later

## Compatibility

| macOS Version | Status |
|---|---|
| macOS 12 Monterey | Supported (minimum) |
| macOS 13 Ventura | Supported |
| macOS 14 Sonoma | Supported |
| macOS 15 Sequoia | Supported |
| macOS 26 Tahoe | Supported |

Works on **Apple Silicon** (M1/M2/M3/M4) and **Intel** Macs.
Designed for **ISO keyboards** (German/European layout with the extra key left of Shift).

## QWERTZ Key Mapping

| Key | Output | Shifted |
|-----|--------|---------|
| `Y` | ы | Ы |
| `Z` | з | З |
| ISO (left of Shift) | ё | Ё |

All other keys follow the standard Russian phonetic mapping (А on `A`, Б on `B`, В on `V`, etc.).

## Installation

### Option A: Package Installer (recommended)

Download `Russian-Phonetic-Max-Installer.pkg` from [Releases](../../releases) and double-click it.

The installer will:
1. Install the layout to `/Library/Keyboard Layouts/`
2. Copy to `~/Library/Keyboard Layouts/` (macOS 26 compatibility)
3. Remove old versions (Russian-MB, previous Russian-Phonetic-Max)
4. Clear keyboard caches and register the layout via TIS

### Option B: Install Script

```bash
git clone https://github.com/citymax24/Russian-Phonetic-Max-macOS.git
cd Russian-Phonetic-Max-macOS
bash install.sh
```

The script will prompt for your admin password.

## After Installation

1. **Remove old Russian layouts**: System Settings → Keyboard → Input Sources → delete any existing Russian layouts
2. **Restart your Mac** (full restart, not just logout)
3. **Add the layout**: System Settings → Keyboard → Input Sources → `+` → Russian → **Russian - Phonetic - Max**
4. **Test**: Switch to the layout and type `Y` → ы, `Z` → з, ISO key → ё

## Building the .pkg Installer

```bash
bash pkg/build-pkg.sh
```

Output: `pkg/output/Russian-Phonetic-Max-Installer.pkg` (~16 KB)

No sudo required for building. Admin rights are only needed when running the installer.

## Project Structure

```
├── Russian-Phonetic-Max.keylayout    # Standalone layout file
├── Russian-Phonetic-Max.bundle/      # macOS keyboard bundle
│   └── Contents/
│       ├── Info.plist
│       ├── version.plist
│       └── Resources/
│           └── Russian-Phonetic-Max.keylayout
├── install.sh                        # Direct install script
├── pkg/
│   ├── build-pkg.sh                  # .pkg build script
│   ├── distribution.xml              # Installer GUI config
│   ├── scripts/postinstall           # Post-install actions
│   └── resources/                    # Installer HTML screens (DE)
│       ├── welcome.html
│       ├── readme.html
│       └── conclusion.html
├── backup/                           # Previous layout versions
├── LICENSE
└── README.md
```

## Technical Details

| | |
|---|---|
| **Keyboard ID** | -20001 |
| **Bundle Identifier** | `org.sil.ukelele.keyboardlayout.russian-phonetic-max` |
| **TIS Source ID** | `org.sil.ukelele.keyboardlayout.russian-phonetic-max.russian-phonetic-max` |
| **Version** | 1.1 |
| **Min macOS** | 12.0 (Monterey) |
| **Architectures** | arm64, x86_64 |
| **Install Paths** | `/Library/Keyboard Layouts/` + `~/Library/Keyboard Layouts/` |

## Uninstalling

Remove the layout files manually:

```bash
sudo rm -rf "/Library/Keyboard Layouts/Russian-Phonetic-Max.bundle"
sudo rm -f  "/Library/Keyboard Layouts/Russian-Phonetic-Max.keylayout"
rm -rf ~/Library/Keyboard\ Layouts/Russian-Phonetic-Max.bundle
rm -f  ~/Library/Keyboard\ Layouts/Russian-Phonetic-Max.keylayout
```

Then restart your Mac.

## License

[MIT](LICENSE) — Max Bollich
