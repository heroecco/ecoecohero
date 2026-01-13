#!/bin/bash
# =============================================================================
# ECO HERO - KEYSTORE GENERATION SCRIPT (macOS/Linux)
# =============================================================================
# 
# This script generates a JKS keystore for Android app signing.
# 
# SECURITY GUARANTEES:
#   ✅ Does NOT collect system information
#   ✅ Does NOT auto-fill any fields
#   ✅ Does NOT read IP addresses
#   ✅ Does NOT access location data
#   ✅ All inputs are manually provided by the user
#
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

clear

echo -e "${CYAN}=============================================================================${NC}"
echo -e "${CYAN}                    ECO HERO - KEYSTORE GENERATOR                           ${NC}"
echo -e "${CYAN}=============================================================================${NC}"
echo ""
echo -e "${WHITE}This script will generate a JKS keystore for Android app signing.${NC}"
echo ""
echo -e "${YELLOW}SECURITY NOTICE:${NC}"
echo -e "${GREEN}  - This script does NOT collect any system information${NC}"
echo -e "${GREEN}  - This script does NOT auto-fill any fields${NC}"
echo -e "${GREEN}  - This script does NOT read IP addresses or location data${NC}"
echo -e "${GREEN}  - All information below is manually entered by YOU${NC}"
echo ""
echo -e "${CYAN}=============================================================================${NC}"
echo ""

# -----------------------------------------------------------------------------
# Check for keytool
# -----------------------------------------------------------------------------
if ! command -v keytool &> /dev/null; then
    echo -e "${RED}ERROR: 'keytool' not found!${NC}"
    echo ""
    echo -e "${YELLOW}Please ensure Java JDK is installed.${NC}"
    echo -e "${YELLOW}You can download it from: https://adoptium.net/${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Found keytool${NC}"
echo ""

# -----------------------------------------------------------------------------
# COLLECT COMPANY INFORMATION (Manual Input Only)
# -----------------------------------------------------------------------------

echo -e "${CYAN}=============================================================================${NC}"
echo -e "${CYAN}                    COMPANY INFORMATION (Required)                          ${NC}"
echo -e "${CYAN}=============================================================================${NC}"
echo ""
echo -e "${WHITE}Please enter the following details. These will be embedded in the keystore.${NC}"
echo -e "${YELLOW}(All fields are required)${NC}"
echo ""

# Company/Organization Name
while true; do
    read -p "1. Company/Organization Name (e.g., EcoHero Games Ltd): " COMPANY_NAME
    if [ -n "$COMPANY_NAME" ]; then break; fi
    echo -e "${RED}   ERROR: Company name is required!${NC}"
done

# Organizational Unit
while true; do
    read -p "2. Organizational Unit (e.g., Mobile Development): " ORG_UNIT
    if [ -n "$ORG_UNIT" ]; then break; fi
    echo -e "${RED}   ERROR: Organizational unit is required!${NC}"
done

# City/Locality
while true; do
    read -p "3. City/Locality (e.g., London): " CITY
    if [ -n "$CITY" ]; then break; fi
    echo -e "${RED}   ERROR: City is required!${NC}"
done

# State/Province
while true; do
    read -p "4. State/Province (e.g., England): " STATE
    if [ -n "$STATE" ]; then break; fi
    echo -e "${RED}   ERROR: State/Province is required!${NC}"
done

# Country Code (2 letters)
while true; do
    read -p "5. Country Code - 2 letters (e.g., GB, US, DE): " COUNTRY
    if [ ${#COUNTRY} -eq 2 ]; then break; fi
    echo -e "${RED}   ERROR: Country code must be exactly 2 letters!${NC}"
done
COUNTRY=$(echo "$COUNTRY" | tr '[:lower:]' '[:upper:]')

echo ""
echo -e "${CYAN}=============================================================================${NC}"
echo -e "${CYAN}                    KEYSTORE CREDENTIALS                                    ${NC}"
echo -e "${CYAN}=============================================================================${NC}"
echo ""
echo -e "${WHITE}Create secure passwords for your keystore.${NC}"
echo -e "${YELLOW}(Minimum 6 characters, use a mix of letters, numbers, and symbols)${NC}"
echo ""

# Key Alias
while true; do
    read -p "6. Key Alias (e.g., ecohero-release, upload): " KEY_ALIAS
    if [ -n "$KEY_ALIAS" ]; then break; fi
    echo -e "${RED}   ERROR: Key alias is required!${NC}"
done

# Keystore Password
while true; do
    read -sp "7. Keystore Password (min 6 characters): " KEYSTORE_PASSWORD
    echo ""
    if [ ${#KEYSTORE_PASSWORD} -ge 6 ]; then break; fi
    echo -e "${RED}   ERROR: Password must be at least 6 characters!${NC}"
done

# Confirm Keystore Password
while true; do
    read -sp "   Confirm Keystore Password: " KEYSTORE_PASSWORD_CONFIRM
    echo ""
    if [ "$KEYSTORE_PASSWORD" == "$KEYSTORE_PASSWORD_CONFIRM" ]; then break; fi
    echo -e "${RED}   ERROR: Passwords do not match!${NC}"
done

# Key Password
while true; do
    read -sp "8. Key Password (min 6 characters, can be same as keystore): " KEY_PASSWORD
    echo ""
    if [ ${#KEY_PASSWORD} -ge 6 ]; then break; fi
    echo -e "${RED}   ERROR: Password must be at least 6 characters!${NC}"
done

# Confirm Key Password
while true; do
    read -sp "   Confirm Key Password: " KEY_PASSWORD_CONFIRM
    echo ""
    if [ "$KEY_PASSWORD" == "$KEY_PASSWORD_CONFIRM" ]; then break; fi
    echo -e "${RED}   ERROR: Passwords do not match!${NC}"
done

echo ""
echo -e "${CYAN}=============================================================================${NC}"
echo -e "${CYAN}                    GENERATING KEYSTORE                                     ${NC}"
echo -e "${CYAN}=============================================================================${NC}"
echo ""

# Build DN (Distinguished Name)
DNAME="CN=$COMPANY_NAME, OU=$ORG_UNIT, O=$COMPANY_NAME, L=$CITY, ST=$STATE, C=$COUNTRY"

# Output file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$(dirname "$SCRIPT_DIR")"
KEYSTORE_FILE="$OUTPUT_DIR/ecohero-release.jks"

# Remove existing keystore if present
if [ -f "$KEYSTORE_FILE" ]; then
    rm -f "$KEYSTORE_FILE"
fi

echo -e "${YELLOW}Generating keystore...${NC}"

# Generate keystore using keytool
keytool -genkey -v \
    -keystore "$KEYSTORE_FILE" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias "$KEY_ALIAS" \
    -dname "$DNAME" \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD"

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo -e "${RED}❌ ERROR: Failed to generate keystore!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Keystore generated successfully!${NC}"
echo ""

# -----------------------------------------------------------------------------
# CONVERT TO BASE64
# -----------------------------------------------------------------------------

echo -e "${YELLOW}Converting keystore to Base64...${NC}"

BASE64_FILE="$OUTPUT_DIR/keystore-base64.txt"
base64 -i "$KEYSTORE_FILE" -o "$BASE64_FILE" 2>/dev/null || base64 "$KEYSTORE_FILE" > "$BASE64_FILE"

echo -e "${GREEN}✅ Base64 conversion complete!${NC}"
echo ""

# -----------------------------------------------------------------------------
# OUTPUT INSTRUCTIONS
# -----------------------------------------------------------------------------

echo -e "${GREEN}=============================================================================${NC}"
echo -e "${GREEN}                    KEYSTORE GENERATED SUCCESSFULLY!                        ${NC}"
echo -e "${GREEN}=============================================================================${NC}"
echo ""
echo -e "${CYAN}📁 Keystore saved to: $KEYSTORE_FILE${NC}"
echo ""
echo -e "${YELLOW}=============================================================================${NC}"
echo -e "${YELLOW}                    GITHUB SECRETS SETUP                                    ${NC}"
echo -e "${YELLOW}=============================================================================${NC}"
echo ""
echo -e "${WHITE}Add the following secrets to your GitHub repository:${NC}"
echo "(Settings > Secrets and variables > Actions > New repository secret)"
echo ""
echo "┌─────────────────────────────────────────────────────────────────────────┐"
echo "│ Secret Name                    │ Value                                  │"
echo "├─────────────────────────────────────────────────────────────────────────┤"
echo "│ ECOHERO_KEYSTORE_BASE64        │ (see base64.txt file)                  │"
echo "│ ECOHERO_KEYSTORE_PASSWORD      │ (your keystore password)               │"
echo "│ ECOHERO_KEY_ALIAS              │ $KEY_ALIAS"
echo "│ ECOHERO_KEY_PASSWORD           │ (your key password)                    │"
echo "└─────────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e "${CYAN}📄 Base64 keystore saved to: $BASE64_FILE${NC}"
echo ""
echo -e "${RED}=============================================================================${NC}"
echo -e "${RED}                    ⚠️  IMPORTANT SECURITY NOTES  ⚠️                        ${NC}"
echo -e "${RED}=============================================================================${NC}"
echo ""
echo -e "${YELLOW}1. NEVER commit the .jks file or base64.txt to version control!${NC}"
echo -e "${YELLOW}2. Store the keystore and passwords in a secure location (password manager)${NC}"
echo -e "${YELLOW}3. If you lose the keystore, you CANNOT update your app on Play Store!${NC}"
echo -e "${YELLOW}4. Delete keystore-base64.txt after adding to GitHub Secrets${NC}"
echo -e "${YELLOW}5. The .gitignore should already exclude these files${NC}"
echo ""
echo -e "${CYAN}=============================================================================${NC}"
echo ""

# Clear sensitive variables from memory
unset KEYSTORE_PASSWORD
unset KEYSTORE_PASSWORD_CONFIRM
unset KEY_PASSWORD
unset KEY_PASSWORD_CONFIRM

echo "Press Enter to exit..."
read
