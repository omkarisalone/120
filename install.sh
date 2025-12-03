#!/bin/bash

# 120fps Gaming Theme Colors
GAMING_GREEN='\033[1;92m'
GAMING_YELLOW='\033[1;93m'
GAMING_ORANGE='\033[1;38;5;214m'
GAMING_BLUE='\033[1;96m'
GAMING_RED='\033[1;91m'
GAMING_PURPLE='\033[1;95m'
GAMING_CYAN='\033[1;96m'
BANNER_COLOR='\033[1;38;5;214m'
NC='\033[0m'

# Progress bar function
progress_bar() {
    local duration=$1
    local step=$2
    local total=$3
    local message=$4
    
    local percentage=$((step * 100 / total))
    local filled=$((percentage / 2))
    local empty=$((50 - filled))
    
    printf "\r${GAMING_CYAN}[${GAMING_ORANGE}"
    printf "%0.s█" $(seq 1 $filled)
    printf "%0.s░" $(seq 1 $empty)
    printf "${GAMING_CYAN}] ${GAMING_YELLOW}%3d%%${NC} - ${GAMING_GREEN}%s${NC}" "$percentage" "$message"
    
    if [ $step -eq $total ]; then
        echo ""
    fi
}

# Banner
echo -e "${BANNER_COLOR}"
echo "╔══════════════════════════════════════════════════╗"
echo "║            @omkarnub TOOL INSTALLER             ║"
echo "║          120fps Modding Tool by omkar           ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running in Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${GAMING_RED}❌ Error: This script must be run in Termux${NC}"
    exit 1
fi

# Function to check command success
check_success() {
    if [ $? -eq 0 ]; then
        echo -e "${GAMING_GREEN}✅ Success${NC}"
    else
        echo -e "${GAMING_RED}❌ Failed${NC}"
    fi
}

# Update packages
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
echo -e "${GAMING_ORANGE}[1] Updating Termux packages...${NC}"
progress_bar 5 1 10 "Updating package list"
pkg update -y
check_success

# Install dependencies
echo -e "${GAMING_ORANGE}[2] Installing dependencies...${NC}"
progress_bar 5 2 10 "Installing packages"
pkg install -y python git wget unzip -o Dpkg::Options::="--force-confnew"
check_success

# Create 120 directory in Termux home
echo -e "${GAMING_ORANGE}[3] Creating 120 directory...${NC}"
progress_bar 5 3 10 "Setting up workspace"
mkdir -p ~/120
cd ~/120
check_success

# Clean previous installations
echo -e "${GAMING_ORANGE}[4] Cleaning previous installations...${NC}"
progress_bar 5 4 10 "Cleaning old files"
rm -f 120.zip
rm -rf 120-main
check_success

# Download the tool
echo -e "${GAMING_ORANGE}[5] Downloading 120fps modding tool...${NC}"
echo -e "${GAMING_CYAN}📥 Downloading from GitHub...${NC}"
progress_bar 10 5 10 "Starting download"
wget -O 120.zip https://github.com/omkarisalone/120/archive/refs/heads/main.zip

if [ ! -f "120.zip" ]; then
    echo -e "${GAMING_RED}❌ Error: Failed to download the tool${NC}"
    exit 1
fi
progress_bar 10 7 10 "Download complete"
check_success

# Extract files
echo -e "${GAMING_ORANGE}[6] Extracting files...${NC}"
progress_bar 5 6 10 "Extracting archive"
unzip -o 120.zip
rm -f 120.zip
progress_bar 5 7 10 "Organizing files"
mv 120-main/* .
rm -rf 120-main
check_success

# Install Python modules
echo -e "${GAMING_ORANGE}[7] Installing Python modules...${NC}"
progress_bar 8 1 8 "Installing requests"
pip install requests > /dev/null 2>&1
progress_bar 8 2 8 "Installing rich"
pip install rich > /dev/null 2>&1
progress_bar 8 3 8 "Installing colorama"
pip install colorama > /dev/null 2>&1
progress_bar 8 4 8 "Installing tqdm"
pip install tqdm > /dev/null 2>&1
progress_bar 8 5 8 "Installing pycryptodome"
pip install pycryptodome > /dev/null 2>&1
progress_bar 8 6 8 "Installing zstandard==0.22.0"
pip install zstandard==0.22.0 > /dev/null 2>&1
progress_bar 8 7 8 "Installing gmalg"
pip install gmalg > /dev/null 2>&1 2>/dev/null || echo -e "${GAMING_YELLOW}[!] gmalg skipped (optional)${NC}"
progress_bar 8 8 8 "Python modules complete"
echo -e "${GAMING_GREEN}✅ Python dependencies installed${NC}"

# Set up the binary executable
echo -e "${GAMING_ORANGE}[8] Setting up executable...${NC}"
progress_bar 5 8 10 "Checking binary"
if [ -f "120" ]; then
    chmod +x 120
    MAIN_FILE="120"
    echo -e "${GAMING_GREEN}✅ Binary executable detected${NC}"
else
    echo -e "${GAMING_RED}❌ Error: Main executable '120' not found${NC}"
    echo -e "${GAMING_YELLOW}📁 Files in directory:${NC}"
    ls -la
    exit 1
fi

# Create alias for easy access
echo -e "${GAMING_ORANGE}[9] Creating command alias...${NC}"
progress_bar 5 9 10 "Setting up command"
# Remove existing aliases
sed -i '/alias 120/d' ~/.bashrc 2>/dev/null
sed -i '/alias 120/d' ~/.zshrc 2>/dev/null

# Create new alias
echo "alias 120='cd ~/120 && ./120'" >> ~/.bashrc

if [ -f ~/.zshrc ]; then
    echo "alias 120='cd ~/120 && ./120'" >> ~/.zshrc
fi

# Create launcher script in Termux bin directory
echo -e "${GAMING_ORANGE}[10] Creating launcher...${NC}"
cat > $PREFIX/bin/120 << EOF
#!/bin/bash
cd ~/120
exec ./120 "\$@"
EOF

chmod +x $PREFIX/bin/120
progress_bar 5 10 10 "Installation complete"
check_success

# Final setup
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
source ~/.bashrc 2>/dev/null

# Display completion message
echo -e "${BANNER_COLOR}"
echo "╔══════════════════════════════════════════════════╗"
echo "║           INSTALLATION 100% COMPLETE!           ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GAMING_GREEN}🎮 120fps Modding Tool successfully installed!${NC}"
echo ""
echo -e "${GAMING_CYAN}🚀 Quick Start:${NC}"
echo -e "   ${GAMING_YELLOW}Type: ${GAMING_ORANGE}120${GAMING_YELLOW} to start the tool${NC}"
echo ""
echo -e "${GAMING_CYAN}📁 Installation Location:${NC}"
echo -e "   ${GAMING_GREEN}~/120/${NC}"
echo ""
echo -e "${GAMING_CYAN}🔧 If '120' command doesn't work:${NC}"
echo -e "   ${GAMING_YELLOW}1. Restart Termux${NC}"
echo -e "   ${GAMING_YELLOW}2. Or run: ${GAMING_GREEN}source ~/.bashrc${NC}"
echo -e "   ${GAMING_YELLOW}3. Or run manually: ${GAMING_GREEN}cd ~/120 && ./120${NC}"
echo ""
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
echo -e "${GAMING_GREEN}💡 The tool is now available anywhere in Termux!${NC}"
echo -e "${GAMING_GREEN}✨ Just type ${GAMING_ORANGE}120${GAMING_GREEN} and press Enter${NC}"
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"

# Show ASCII art
echo -e "${GAMING_CYAN}"
echo "    ___   ___   ___   "
echo "   | 1 | | 2 | | 0 |  "
echo "   ‾‾‾   ‾‾‾   ‾‾‾    "
echo "  ┌─────────────────┐ "
echo "  │ 120fps MODDING  │ "
echo "  │     TOOL READY  │ "
echo "  └─────────────────┘ "
echo -e "${NC}"