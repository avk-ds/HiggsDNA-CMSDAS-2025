#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
GIT_COMMIT='8e64be382f90ed94a74d3201509e24d302b75355'

check_higgs_dna_import(){
    if ! python -c "import higgs_dna" 2>/dev/null; then
        echo -e "${RED}[CHECK-ERROR]${NC} 'higgs_dna' module is not available. Need to check if the path is not properly configured."
        IMPORT_OK=0
        
    else
        echo -e "${GREEN}[CHECKPOINT]${NC} 'higgs_dna' module is available. The path is properly configured."
        IMPORT_OK=1
    fi
}

echo "
██   ██ ██  ██████   ██████  ███████     ██████  ███    ██  █████      ██ ███    ██ ███████ ████████  █████  ██      ██      ███████ ██████  
██   ██ ██ ██       ██       ██          ██   ██ ████   ██ ██   ██     ██ ████   ██ ██         ██    ██   ██ ██      ██      ██      ██   ██ 
███████ ██ ██   ███ ██   ███ ███████     ██   ██ ██ ██  ██ ███████     ██ ██ ██  ██ ███████    ██    ███████ ██      ██      █████   ██████  
██   ██ ██ ██    ██ ██    ██      ██     ██   ██ ██  ██ ██ ██   ██     ██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██      ██   ██ 
██   ██ ██  ██████   ██████  ███████     ██████  ██   ████ ██   ██     ██ ██   ████ ███████    ██    ██   ██ ███████ ███████ ███████ ██   ██ 
"
echo -e "${GREEN}Higgs DNA Installation Script written by Avik Das, Research Scholar, DHEP, TIFR Mumbai${NC}"
echo -e "${GREEN}===========================================================================================================================================${NC}"
echo -e "${BLUE}[INFO]${NC} This script will install Higgs DNA on your system."
echo -e "${BLUE}[INFO]${NC} The git commit- ${GIT_COMMIT} for HiggsDNA Installation. To change the commit, please edit the script. Search for 'GIT_COMMIT' variable."
# This script installs Higgs DNA on a Linux system.
read -p "$(echo -e "${BLUE}[INFO]${NC}Do you want to install micromamba? If you already have a micromamba installation press - n (y/n/d): ")" install_micromamba

if [[ "$install_micromamba" == "y" || "$install_micromamba" == "Y" ]]; then
    echo -e "${BLUE}[INFO]${NC}Current working directory: ${GREEN}$(pwd)${NC}"
    read -p "$(echo -e "${BLUE}[INFO]${NC}Do you want to install micromamba in the current working directory: ${GREEN}$(pwd)${NC}(y/n): ")" install_here
    if [[ "$install_here" == "y" || "$install_here" == "Y" ]]; then
        echo -e "${BLUE}[INFO]${NC}Installing micromamba "
        "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
        echo -e "${GREEN}[CHECKPOINT]${NC}Micromamba installed successfully!$"
    else
        echo -e "${RED}[ERROR]${NC}Please copy this script to the directory where you want to install everything."
    fi
else
    echo "${BLUE}[ERROR]${NC}Skipping micromamba installation."
fi

if [[ "$install_micromamba" != "d" && "$install_micromamba" != "D" ]]; then
    echo -e "${BLUE}[INFO]${NC}You have chosen to skip micromamba installation. Please ensure micromamba is installed and available in your PATH."
    echo -e "${BLUE}[INFO]${NC}GitClone and higgs-dna environment creation will go on."
    echo -e "${BLUE}[INFO]${NC}If you want to install micromamba later, please run the script again with 'y' option."
    echo -e "${BLUE}[INFO]${NC}Clonning Higgs DNA Repo"
    git clone https://gitlab.cern.ch/HiggsDNA-project/HiggsDNA.git
    cd HiggsDNA
    echo -e "${BLUE}[INFO]${NC}Higgs DNA Repo cloned successfully!"
    git reset --hard ${GIT_COMMIT}
    echo -e "${BLUE}[INFO]${NC}Resetting Higgs DNA Repo to a working commit"
    echo -e "${BLUE}[INFO]${NC}Current commit version $(git rev-parse HEAD)"
    echo -e "${BLUE}[INFO]${NC}}Creating Higgs DNA environment"
    eval "$(micromamba shell hook --shell )" 
    micromamba env create -f environment.yml
    echo -e "${BLUE}[INFO]${NC}Higgs DNA environment created successfully!"
fi

if [[ "$install_micromamba" == "d" || "$install_micromamba" == "D" ]]; then
    echo -e "${BLUE}[INFO]${NC}You have chosen to skip micromamba installation. Please ensure micromamba is installed and available in your PATH."
    echo -e "${BLUE}[INFO]${NC}GitClone and higgs-dna environment creation will also be skipped."
    echo -e "${BLUE}[INFO]${NC}Make sure this script is getting executed just outside of HiggsDNA (from git-clone)."
fi
echo -e "${BLUE}[INFO]${NC}Activating Higgs DNA environment${NC}"
#source ~/.bashrc
#micromamba activate higgs-dna
eval "$(micromamba shell hook --shell bash)"
if micromamba activate higgs-dna; then
    echo -e "${BLUE}[INFO]${NC}Activated micromamba environment 'higgs-dna' successfully."
    echo -e "${GREEN}[CHECKPOINT]${NC}Higgs DNA environment is now active. Proceeding to checks."
else
    echo "${RED}[ERROR]${NC} Failed to activate micromamba environment 'higgs-dna'. Please ensure micromamba is installed and the environment exists."
    exit 1
fi

#############Check 1###############
check_higgs_dna_import
if [[ $IMPORT_OK -eq 0 ]]; then
    echo -e "${BLUE}[INFO]${NC} Checking if 'HiggsDNA' is added to the path."
    if ! python -c "import sys; print('\n'.join(sys.path))" | grep -q "HiggsDNA"; then
        echo -e "${BLUE}[INFO]${NC} HiggsDNA is not available in the Python path. Adding it now."
        SITE_PACKAGES_PATH=$(python -c "import sys; print('\n'.join(sys.path))" | grep site-packages | grep higgs-dna | head -n 1)
        HIGGS_DNA_PATH=$(realpath HiggsDNA)
        echo "$HIGGS_DNA_PATH" >> "$SITE_PACKAGES_PATH/_higgs_dna.pth"
    fi
fi

micromamba deactivate
eval "$(micromamba shell hook --shell bash)"
micromamba activate higgs-dna
check_higgs_dna_import

if [[ $IMPORT_OK -eq 0 ]]; then
    echo -e "${RED}[CHECK-ERROR]${NC} 'higgs_dna' module is still not available after adding to the path. Please check the installation."
    exit 1
fi
###############Check 2###############
if python3 $HIGGS_DNA_PATH/higgs_dna/scripts/run_analysis.py --help >/dev/null 2>&1; then
    echo -e "${GREEN}[CHECKPOINT]${NC} run_analysis.py --help ran successfully."
else
    echo -e "${RED}[CHECK-ERROR]${NC} run_analysis.py --help did not run."
    exit 1
fi