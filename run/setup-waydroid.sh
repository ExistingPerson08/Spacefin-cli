#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

Urllink() {
    echo -e "\e]8;;$1\a$2\e]8;;\a"
}

Choose() {
    echo "Please choose an option:" >&2
    select opt in "$@"; do
        if [ -n "$opt" ]; then
            echo "$opt"
            break
        fi
    done
}

OPTION=$1 

if [ "$OPTION" == "help" ]; then
  echo "Usage: ./setup-waydroid.sh <option>"
  echo "  <option>: Specify the quick option to skip the prompt"
  echo "  Use 'init' to select Initialize Waydroid"
  echo "  Use 'configure' to select Configure Waydroid"
  echo "  Use 'gpu' to choose Select GPU for Waydroid"
  echo "  Use 'integration' to enable desktop window integration"
  echo "  Use 'reset' to select Reset Waydroid"
  exit 0
elif [ "$OPTION" == "" ]; then
  echo "${bold}Waydroid Setup${normal}"
  echo "Please read the documentation before continuing:"
  Urllink "https://docs.waydro.id/" "Waydroid Setup Guide"
  echo -e "\n"
  OPTION=$(Choose "Initialize Waydroid" "Configure Waydroid" "Select GPU for Waydroid" "Enable Desktop Integration" "Reset Waydroid")
fi

OPTION_LOWER=$(echo "$OPTION" | tr '[:upper:]' '[:lower:]')

if [[ "$OPTION_LOWER" =~ ^init ]]; then
  echo "Enabling Waydroid container service..."
  sudo systemctl enable --now waydroid-container
  
  echo "Configuring UFW rules for Waydroid networking..."
  sudo ufw route allow in on waydroid0
  sudo ufw route allow out on waydroid0
  sudo ufw allow in on waydroid0
  
  echo "Initializing Waydroid. This might take a bit, please be patient..."
  sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'
  
  sudo systemctl restart waydroid-container
  echo "Waydroid has been initialized. Please run Waydroid once before you Configure Waydroid."

elif [[ "$OPTION_LOWER" =~ ^configure ]]; then
  echo "Downloading configuration scripts..."
  git clone https://github.com/casualsnek/waydroid_script.git --depth 1 /tmp/waydroid_script
  python -m venv /tmp/waydroid_script/venv
  source /tmp/waydroid_script/venv/bin/activate
  pip install -r /tmp/waydroid_script/requirements.txt
  sudo /tmp/waydroid_script/main.py
  deactivate
  rm -rf /tmp/waydroid_script

elif [[ "$OPTION_LOWER" =~ gpu ]]; then
  if [ -f "/usr/bin/waydroid-choose-gpu" ]; then
    sudo /usr/bin/waydroid-choose-gpu
  else
    echo "Error: waydroid-choose-gpu not found. Please install it from AUR."
  fi

elif [[ "$OPTION_LOWER" =~ integration ]]; then
  echo "Enabling multi-window integration..."
  waydroid prop set persist.waydroid.multi_windows true
  echo "Please restart Waydroid for changes to take effect."

elif [[ "$OPTION_LOWER" =~ ^reset ]]; then
  echo "Resetting Waydroid..."
  sudo waydroid session stop 2>/dev/null
  sudo systemctl stop waydroid-container
  sudo rm -rf /var/lib/waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*waydroid* ~/.local/share/waydroid
  echo "Waydroid has been reset and all data removed."
fi
