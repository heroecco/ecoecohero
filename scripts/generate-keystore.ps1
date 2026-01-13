<#
.SYNOPSIS
    Eco Hero - Keystore Generation Script
    
.DESCRIPTION
    This script generates a JKS keystore for signing Android apps.
    It prompts for company information ONLY and does NOT collect any
    system, user, IP, or location data.

.NOTES
    SECURITY NOTICE:
    - This script does NOT read any system information
    - This script does NOT auto-fill any fields
    - This script does NOT collect IP addresses or location data
    - All information is manually entered by the user
    - The keystore is output in Base64 for GitHub Secrets

.EXAMPLE
    .\generate-keystore.ps1
#>

# =============================================================================
# ECO HERO - KEYSTORE GENERATION SCRIPT
# =============================================================================

Clear-Host

Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host "                    ECO HERO - KEYSTORE GENERATOR                           " -ForegroundColor Cyan
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will generate a JKS keystore for Android app signing." -ForegroundColor White
Write-Host ""
Write-Host "SECURITY NOTICE:" -ForegroundColor Yellow
Write-Host "  - This script does NOT collect any system information" -ForegroundColor Green
Write-Host "  - This script does NOT auto-fill any fields" -ForegroundColor Green
Write-Host "  - This script does NOT read IP addresses or location data" -ForegroundColor Green
Write-Host "  - All information below is manually entered by YOU" -ForegroundColor Green
Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# Check for keytool
# -----------------------------------------------------------------------------
$keytoolPath = $null

# Try to find keytool in common locations
$possiblePaths = @(
    "keytool",
    "$env:JAVA_HOME\bin\keytool.exe",
    "C:\Program Files\Java\jdk*\bin\keytool.exe",
    "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    "C:\Program Files\Eclipse Adoptium\jdk*\bin\keytool.exe"
)

foreach ($path in $possiblePaths) {
    $resolved = Get-Command $path -ErrorAction SilentlyContinue
    if ($resolved) {
        $keytoolPath = $resolved.Source
        break
    }
    
    # Try wildcard paths
    $wildcardResults = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($wildcardResults) {
        $keytoolPath = $wildcardResults.FullName
        break
    }
}

if (-not $keytoolPath) {
    Write-Host "ERROR: 'keytool' not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please ensure Java JDK is installed and JAVA_HOME is set." -ForegroundColor Yellow
    Write-Host "You can download it from: https://adoptium.net/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Found keytool at: $keytoolPath" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# COLLECT COMPANY INFORMATION (Manual Input Only)
# -----------------------------------------------------------------------------

Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host "                    COMPANY INFORMATION (Required)                          " -ForegroundColor Cyan
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please enter the following details. These will be embedded in the keystore." -ForegroundColor White
Write-Host "(All fields are required)" -ForegroundColor Yellow
Write-Host ""

# Company/Organization Name
do {
    $companyName = Read-Host "1. Company/Organization Name (e.g., EcoHero Games Ltd)"
    if ([string]::IsNullOrWhiteSpace($companyName)) {
        Write-Host "   ERROR: Company name is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($companyName))

# Organizational Unit
do {
    $orgUnit = Read-Host "2. Organizational Unit (e.g., Mobile Development)"
    if ([string]::IsNullOrWhiteSpace($orgUnit)) {
        Write-Host "   ERROR: Organizational unit is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($orgUnit))

# City/Locality
do {
    $city = Read-Host "3. City/Locality (e.g., London)"
    if ([string]::IsNullOrWhiteSpace($city)) {
        Write-Host "   ERROR: City is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($city))

# State/Province
do {
    $state = Read-Host "4. State/Province (e.g., England)"
    if ([string]::IsNullOrWhiteSpace($state)) {
        Write-Host "   ERROR: State/Province is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($state))

# Country Code (2 letters)
do {
    $country = Read-Host "5. Country Code - 2 letters (e.g., GB, US, DE)"
    if ([string]::IsNullOrWhiteSpace($country) -or $country.Length -ne 2) {
        Write-Host "   ERROR: Country code must be exactly 2 letters!" -ForegroundColor Red
        $country = ""
    }
} while ([string]::IsNullOrWhiteSpace($country))
$country = $country.ToUpper()

Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host "                    KEYSTORE CREDENTIALS                                    " -ForegroundColor Cyan
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Create secure passwords for your keystore." -ForegroundColor White
Write-Host "(Minimum 6 characters, use a mix of letters, numbers, and symbols)" -ForegroundColor Yellow
Write-Host ""

# Key Alias
do {
    $keyAlias = Read-Host "6. Key Alias (e.g., ecohero-release, upload)"
    if ([string]::IsNullOrWhiteSpace($keyAlias)) {
        Write-Host "   ERROR: Key alias is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($keyAlias))

# Keystore Password
do {
    $keystorePassword = Read-Host "7. Keystore Password (min 6 characters)" -AsSecureString
    $keystorePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keystorePassword)
    )
    if ($keystorePasswordPlain.Length -lt 6) {
        Write-Host "   ERROR: Password must be at least 6 characters!" -ForegroundColor Red
        $keystorePasswordPlain = ""
    }
} while ([string]::IsNullOrWhiteSpace($keystorePasswordPlain))

# Confirm Keystore Password
do {
    $keystorePasswordConfirm = Read-Host "   Confirm Keystore Password" -AsSecureString
    $keystorePasswordConfirmPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keystorePasswordConfirm)
    )
    if ($keystorePasswordPlain -ne $keystorePasswordConfirmPlain) {
        Write-Host "   ERROR: Passwords do not match!" -ForegroundColor Red
        $keystorePasswordConfirmPlain = ""
    }
} while ($keystorePasswordPlain -ne $keystorePasswordConfirmPlain)

# Key Password
do {
    $keyPassword = Read-Host "8. Key Password (min 6 characters, can be same as keystore)" -AsSecureString
    $keyPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPassword)
    )
    if ($keyPasswordPlain.Length -lt 6) {
        Write-Host "   ERROR: Password must be at least 6 characters!" -ForegroundColor Red
        $keyPasswordPlain = ""
    }
} while ([string]::IsNullOrWhiteSpace($keyPasswordPlain))

# Confirm Key Password
do {
    $keyPasswordConfirm = Read-Host "   Confirm Key Password" -AsSecureString
    $keyPasswordConfirmPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPasswordConfirm)
    )
    if ($keyPasswordPlain -ne $keyPasswordConfirmPlain) {
        Write-Host "   ERROR: Passwords do not match!" -ForegroundColor Red
        $keyPasswordConfirmPlain = ""
    }
} while ($keyPasswordPlain -ne $keyPasswordConfirmPlain)

Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host "                    GENERATING KEYSTORE                                     " -ForegroundColor Cyan
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""

# Build DN (Distinguished Name)
$dname = "CN=$companyName, OU=$orgUnit, O=$companyName, L=$city, ST=$state, C=$country"

# Output file - use the scripts folder's parent directory
$outputDir = Split-Path -Parent $PSScriptRoot
$keystoreFile = Join-Path $outputDir "ecohero-release.jks"

# Remove existing keystore if present
if (Test-Path $keystoreFile) {
    Remove-Item $keystoreFile -Force
}

Write-Host "Generating keystore..." -ForegroundColor Yellow
Write-Host "Output path: $keystoreFile" -ForegroundColor Gray

try {
    # Build the argument string with proper quoting for paths with spaces
    $argString = "-genkey -v " +
        "-keystore `"$keystoreFile`" " +
        "-keyalg RSA " +
        "-keysize 2048 " +
        "-validity 10000 " +
        "-alias `"$keyAlias`" " +
        "-dname `"$dname`" " +
        "-storepass `"$keystorePasswordPlain`" " +
        "-keypass `"$keyPasswordPlain`""
    
    # Run keytool with Start-Process and the argument string
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $keytoolPath
    $psi.Arguments = $argString
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    
    $process = [System.Diagnostics.Process]::Start($psi)
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    
    if ($stdout) { Write-Host $stdout }
    if ($stderr) { Write-Host $stderr }
    
    if ($process.ExitCode -ne 0) {
        throw "keytool exited with code $($process.ExitCode)"
    }
    
    if (-not (Test-Path $keystoreFile)) {
        throw "Keystore file was not created"
    }
    
    Write-Host "Keystore generated successfully!" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "ERROR: Failed to generate keystore!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# -----------------------------------------------------------------------------
# CONVERT TO BASE64
# -----------------------------------------------------------------------------

Write-Host "Converting keystore to Base64..." -ForegroundColor Yellow

$keystoreBytes = [System.IO.File]::ReadAllBytes($keystoreFile)
$keystoreBase64 = [System.Convert]::ToBase64String($keystoreBytes)

Write-Host "Base64 conversion complete!" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# OUTPUT INSTRUCTIONS
# -----------------------------------------------------------------------------

Write-Host "=============================================================================" -ForegroundColor Green
Write-Host "                    KEYSTORE GENERATED SUCCESSFULLY!                        " -ForegroundColor Green
Write-Host "=============================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Keystore saved to: $keystoreFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Yellow
Write-Host "                    GITHUB SECRETS SETUP                                    " -ForegroundColor Yellow
Write-Host "=============================================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add the following secrets to your GitHub repository:" -ForegroundColor White
Write-Host "(Settings -> Secrets and variables -> Actions -> New repository secret)" -ForegroundColor Gray
Write-Host ""
Write-Host "SECRET NAME                      VALUE" -ForegroundColor DarkGray
Write-Host "-------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "ECOHERO_KEYSTORE_BASE64          (see keystore-base64.txt file)" -ForegroundColor White
Write-Host "ECOHERO_KEYSTORE_PASSWORD        (your keystore password)" -ForegroundColor White
Write-Host "ECOHERO_KEY_ALIAS                $keyAlias" -ForegroundColor White
Write-Host "ECOHERO_KEY_PASSWORD             (your key password)" -ForegroundColor White
Write-Host "-------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# Save Base64 to file
$base64File = Join-Path $outputDir "keystore-base64.txt"
$keystoreBase64 | Out-File -FilePath $base64File -Encoding UTF8 -NoNewline

Write-Host "Base64 keystore saved to: $base64File" -ForegroundColor Cyan
Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Red
Write-Host "                    IMPORTANT SECURITY NOTES                                " -ForegroundColor Red
Write-Host "=============================================================================" -ForegroundColor Red
Write-Host ""
Write-Host "1. NEVER commit the .jks file or base64.txt to version control!" -ForegroundColor Yellow
Write-Host "2. Store the keystore and passwords in a secure location (password manager)" -ForegroundColor Yellow
Write-Host "3. If you lose the keystore, you CANNOT update your app on Play Store!" -ForegroundColor Yellow
Write-Host "4. Delete keystore-base64.txt after adding to GitHub Secrets" -ForegroundColor Yellow
Write-Host "5. The .gitignore should already exclude these files" -ForegroundColor Yellow
Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""

# Clear sensitive variables from memory
$keystorePasswordPlain = $null
$keyPasswordPlain = $null
$keystorePasswordConfirmPlain = $null
$keyPasswordConfirmPlain = $null

Write-Host "Press Enter to exit..." -ForegroundColor Gray
Read-Host
