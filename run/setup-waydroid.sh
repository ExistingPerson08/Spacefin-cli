#!/usr/bin/bash
# name: Setup Waydroid

bold=$(tput bold)
normal=$(tput sgr0)
cursor_off=$(tput civis)
cursor_on=$(tput cnorm)

Urllink() {
    echo -e "\e]8;;$1\a$2\e]8;;\a"
}

Choose() {
    local options=("$@")
    local selected=0
    local key=""

    # Hide cursor
    echo -ne "$cursor_off"

    while true; do
        # Print menu
        for i in "${!options[@]}"; do
            if [ "$i" -eq "$selected" ]; then
                echo -e "  ${bold}> ${options[$i]}${normal}"
            else
                echo -e "    ${options[$i]}"
            fi
        done

        IFS= read -rsn1 key
        if [[ "$key" == $'\x1b' ]]; then
            read -rsn2 key
            if [[ "$key" == "[A" ]]; then # Up arrow
                ((selected--))
                [ "$selected" -lt 0 ] && selected=$((${#options[@]} - 1))
            elif [[ "$key" == "[B" ]]; then # Down arrow
                ((selected++))
                [ "$selected" -ge "${#options[@]}" ] && selected=0
            fi
        elif [[ "$key" == "" ]]; then # Enter key
            break
        fi

        echo -ne "\033[${#options[@]}A"
    done

    echo -ne "$cursor_on"
    echo "${options[$selected]}"
}

# --- Script Logic ---
OPTION=$1 

if [ "$OPTION" == "help" ]; then
  echo "Usage: ./setup-waydroid.sh <option>"
  echo "  Use 'init', 'configure', 'gpu', 'integration', or 'reset'"
  exit 0
elif [ "$OPTION" == "" ]; then
  echo "${bold}Waydroid Setup${normal}"
  echo "Please read the documentation before continuing:"
  Urllink "https://docs.waydro.id/" "Waydroid Setup Guide"
  echo -e "\n(Use arrow keys to navigate, Enter to select)\n"
  
  OPTION=$(Choose "Initialize Waydroid" "Configure Waydroid" "Select GPU for Waydroid" "Enable Desktop Integration" "Reset Waydroid")
  echo -e "\nSelected: $OPTION\n"
fi

OPTION_LOWER=$(echo "$OPTION" | tr '[:upper:]' '[:lower:]')

# --- 1. INITIALIZE ---
if [[ "$OPTION_LOWER" =~ ^init ]]; then
  echo "Enabling Waydroid container service..."
  sudo systemctl enable --now waydroid-container
  
  echo "Configuring UFW rules for Waydroid..."
  sudo ufw route allow in on waydroid0
  sudo ufw route allow out on waydroid0
  sudo ufw allow in on waydroid0
  
  echo "Initializing Waydroid (Downloading images)..."
  sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'
  
  sudo systemctl restart waydroid-container
  echo "Waydroid initialized. Launch it once before configuring."

# --- 2. CONFIGURE ---
elif [[ "$OPTION_LOWER" =~ ^configure ]]; then
  echo "Downloading configuration scripts..."
  git clone https://github.com/casualsnek/waydroid_script.git --depth 1 /tmp/waydroid_script
  python -m venv /tmp/waydroid_script/venv
  source /tmp/waydroid_script/venv/bin/activate
  pip install -r /tmp/waydroid_script/requirements.txt
  sudo /tmp/waydroid_script/main.py
  deactivate
  rm -rf /tmp/waydroid_script

# --- 3. GPU ---
elif [[ "$OPTION_LOWER" =~ gpu ]]; then
  if [ -f "/usr/bin/waydroid-choose-gpu" ]; then
    sudo /usr/bin/waydroid-choose-gpu
  else
    echo "Error: waydroid-choose-gpu not found. Install it from AUR."
  fi

# --- 4. INTEGRATION ---
elif [[ "$OPTION_LOWER" =~ integration ]]; then
  echo "Enabling multi-window integration..."
  waydroid prop set persist.waydroid.multi_windows true
  echo "Restart Waydroid to apply."

# --- 5. RESET ---
elif [[ "$OPTION_LOWER" =~ ^reset ]]; then
  echo "Resetting Waydroid..."
  sudo waydroid session stop 2>/dev/null
  sudo systemctl stop waydroid-container
  sudo rm -rf /var/lib/waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*waydroid* ~/.local/share/waydroid
  echo "Waydroid has been reset."
fi
