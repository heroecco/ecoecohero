# 🔐 Eco Hero - Android Signing Setup Guide

This guide explains how to generate a signing keystore and configure GitHub Actions to automatically build signed APK and AAB files.

---

## 📋 Table of Contents

1. [Security Guarantees](#-security-guarantees)
2. [Prerequisites](#-prerequisites)
3. [Step 1: Generate Keystore](#-step-1-generate-keystore)
4. [Step 2: Add GitHub Secrets](#-step-2-add-github-secrets)
5. [Step 3: Push and Build](#-step-3-push-and-build)
6. [Step 4: Download Artifacts](#-step-4-download-artifacts)
7. [Troubleshooting](#-troubleshooting)

---

## 🛡️ Security Guarantees

The keystore generation script:

| ✅ Guarantee | Description |
|-------------|-------------|
| No System Data | Does NOT collect system information |
| No Auto-Fill | Does NOT auto-fill any fields |
| No IP Collection | Does NOT read IP addresses |
| No Location Data | Does NOT access location information |
| Manual Input Only | ALL information is manually entered by you |

The GitHub Actions workflow:

| ✅ Guarantee | Description |
|-------------|-------------|
| Secrets Only | Keystore and passwords stored in GitHub Secrets only |
| No Log Exposure | Secrets are NEVER printed to logs |
| Secure Cleanup | Keystore is deleted after build |
| Release Mode Only | Builds are ALWAYS in release mode (not debug) |

---

## 📦 Prerequisites

- **Java JDK 11+** installed (for `keytool` command)
  - Download: https://adoptium.net/
- **Git** installed and configured
- **GitHub repository** with Actions enabled

---

## 🔑 Step 1: Generate Keystore

### Windows (PowerShell)

```powershell
# Navigate to project folder
cd "C:\path\to\Eco Hero"

# Run the keystore generator
.\scripts\generate-keystore.ps1
```

### macOS / Linux (Bash)

```bash
# Navigate to project folder
cd /path/to/eco-hero

# Make script executable
chmod +x scripts/generate-keystore.sh

# Run the keystore generator
./scripts/generate-keystore.sh
```

### What the script will ask:

| # | Field | Example |
|---|-------|---------|
| 1 | Company/Organization Name | EcoHero Games Ltd |
| 2 | Organizational Unit | Mobile Development |
| 3 | City/Locality | London |
| 4 | State/Province | England |
| 5 | Country Code (2 letters) | GB |
| 6 | Key Alias | ecohero-release |
| 7 | Keystore Password | (your secure password) |
| 8 | Key Password | (your secure password) |

### Output files:

After running the script, you'll have:

- `ecohero-release.jks` - The keystore file (KEEP SECURE!)
- `keystore-base64.txt` - Base64 encoded keystore for GitHub

> ⚠️ **IMPORTANT**: Store the `.jks` file and passwords in a secure location (password manager). If you lose them, you cannot update your app on Play Store!

---

## 🔒 Step 2: Add GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these 4 secrets:

| Secret Name | Value |
|-------------|-------|
| `ECOHERO_KEYSTORE_BASE64` | Contents of `keystore-base64.txt` |
| `ECOHERO_KEYSTORE_PASSWORD` | Your keystore password |
| `ECOHERO_KEY_ALIAS` | Your key alias (e.g., `ecohero-release`) |
| `ECOHERO_KEY_PASSWORD` | Your key password |

### How to add the Base64 keystore:

1. Open `keystore-base64.txt`
2. Copy the ENTIRE contents (it's one long string)
3. Paste it as the value for `ECOHERO_KEYSTORE_BASE64`

> 🗑️ After adding secrets, DELETE `keystore-base64.txt` from your computer.

---

## 🚀 Step 3: Push and Build

The workflow triggers automatically on:

- Push to `main`, `master`, or `develop` branches
- Pull requests to `main` or `master`
- Manual trigger from Actions tab

### Manual trigger:

1. Go to **Actions** tab in GitHub
2. Select **Android Build** workflow
3. Click **Run workflow**

---

## 📥 Step 4: Download Artifacts

After a successful build:

1. Go to **Actions** tab
2. Click on the completed workflow run
3. Scroll down to **Artifacts** section
4. Download:
   - `eco-hero-apk-{commit}` - Signed APK
   - `eco-hero-aab-{commit}` - Signed AAB (for Play Store)

Artifacts are retained for **30 days**.

---

## ❓ Troubleshooting

### "keytool not found" error

**Windows:**
```powershell
# Set JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.x.x"
$env:PATH += ";$env:JAVA_HOME\bin"
```

**macOS/Linux:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH
```

### "Keystore was tampered with" error

The keystore password is incorrect. Double-check the `ECOHERO_KEYSTORE_PASSWORD` secret.

### "R8: Missing class com.google.android.play.core..." error

The proguard-rules.pro should already include `-dontwarn` rules for Play Core classes. If you still see this:

1. Verify `android/app/proguard-rules.pro` exists
2. Verify `build.gradle.kts` references it in the release build type

### Build fails with "No key with alias found"

The key alias is incorrect. Double-check:
1. The `ECOHERO_KEY_ALIAS` secret matches what you entered during keystore creation
2. Key aliases are case-sensitive

### APK is not signed

Check the workflow logs for any errors during:
1. Keystore decoding
2. key.properties creation
3. Flutter build

---

## 📁 Files Reference

| File | Purpose |
|------|---------|
| `.github/workflows/android-build.yml` | GitHub Actions workflow |
| `scripts/generate-keystore.ps1` | Windows keystore generator |
| `scripts/generate-keystore.sh` | macOS/Linux keystore generator |
| `android/app/proguard-rules.pro` | R8/ProGuard configuration |
| `android/key.properties` | (Generated at build time, never committed) |

---

## 🔗 Additional Resources

- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

---

**Last updated:** January 2026
