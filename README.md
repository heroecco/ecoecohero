# 🎮 Eco Hero

A Flutter mobile game where players clean up ocean pollution while navigating underwater environments.

## 📱 Building the App

### Local Development

```bash
# Get dependencies
flutter pub get

# Run in debug mode
flutter run

# Build debug APK (no signing required)
flutter build apk --debug
```

### Release Builds (Signed)

Release builds require a signing keystore. See [SIGNING_SETUP.md](SIGNING_SETUP.md) for detailed instructions.

## 🔐 Android Signing Setup

### Quick Start

1. **Generate a keystore** (run once, keep secure):

   **Windows:**
   ```powershell
   .\scripts\generate-keystore.ps1
   ```

   **macOS/Linux:**
   ```bash
   chmod +x scripts/generate-keystore.sh
   ./scripts/generate-keystore.sh
   ```

2. **Add GitHub Secrets** (Settings → Secrets and variables → Actions):

   | Secret Name | Value |
   |-------------|-------|
   | `ECOHERO_KEYSTORE_BASE64` | Contents of `keystore-base64.txt` |
   | `ECOHERO_KEYSTORE_PASSWORD` | Your keystore password |
   | `ECOHERO_KEY_ALIAS` | Your key alias |
   | `ECOHERO_KEY_PASSWORD` | Your key password |

3. **Push to GitHub** - The workflow builds automatically on push to `main`, `master`, or `develop`.

4. **Download artifacts** from the Actions tab.

### Security Guarantees

The keystore generation script:
- ✅ Does **NOT** collect system information
- ✅ Does **NOT** auto-fill any fields
- ✅ Does **NOT** read IP addresses or location data
- ✅ All information is manually entered by the user

The GitHub Actions workflow:
- ✅ Uses GitHub Secrets only (no hardcoded credentials)
- ✅ Never prints secrets to logs
- ✅ Securely deletes keystore after build
- ✅ Release mode only (no debug fallback)

## 📁 Project Structure

```
Eco Hero/
├── lib/                    # Flutter/Dart source code
│   ├── data/               # Game data (levels, player, skins)
│   ├── game/               # Game engine components
│   ├── screens/            # UI screens
│   ├── utils/              # Utilities
│   └── widgets/            # Reusable widgets
├── android/                # Android platform code
├── ios/                    # iOS platform code
├── assets/                 # Images, audio, fonts
├── scripts/                # Build scripts
└── .github/workflows/      # CI/CD workflows
```

## 🔧 Troubleshooting

### "keytool not found"

Ensure Java JDK is installed and `JAVA_HOME` is set. Download from [Adoptium](https://adoptium.net/).

### "Keystore was tampered with"

The keystore password is incorrect. Verify `ECOHERO_KEYSTORE_PASSWORD` secret.

### "No key with alias found"

The key alias is incorrect or doesn't exist. Key aliases are case-sensitive.

### R8/ProGuard errors about Play Core

The `proguard-rules.pro` file includes `-dontwarn` rules for Play Core classes. If you see new missing class errors, add them to the proguard rules.

## 📄 License

Copyright © 2026 EcoHero Games. All rights reserved.
