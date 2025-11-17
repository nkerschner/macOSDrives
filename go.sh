#!/bin/bash 


# macOS Installation and Elevated Security Removal Tool
# v3.0-beta
# https://github.com/nkerschner/macOSDrives


cd /
userQuit=0

# declare default paths
ASR_IMAGE_PATH="/Volumes/ASR/"
INSTALLER_VOLUME_PATH="/Volumes/FULL/Applications/"
ES_SOURCE_PATH="/Volumes/ASR/cat.dmg"
ALT_ES_SOURCE_PATH="Volumes/e/cat.dmg"
INTERNAL_VOLUME_NAME="Macintosh HD"
INTERNAL_VOLUME_PATH="/Volumes/Macintosh HD"

# Declare arrays for each MacOS version and compatible devices
declare -a Catalina=("MacBookAir5,1" "MacBookAir5,2" "MacBookAir6,1" "MacBookAir6,2" "MacBookAir7,1" \
  "MacBookAir7,2" "MacBookAir8,1" "MacBookAir8,2" "MacBookAir9,1" "MacBook8,1" \
  "MacBook9,1" "MacBook10,1" "MacBookPro9,1" "MacBookPro9,2" "MacBookPro10,1" \
  "MacBookPro10,2" "MacBookPro11,1" "MacBookPro11,2" "MacBookPro11,3" "MacBookPro11,4" \
  "MacBookPro11,5" "MacBookPro12,1" "MacBookPro13,1" "MacBookPro13,2" "MacBookPro13,3" \
  "MacBookPro14,1" "MacBookPro14,2" "MacBookPro14,3" "MacBookPro15,1" "MacBookPro15,2" \
  "MacBookPro15,3" "MacBookPro15,4" "MacBookPro16,1" "MacBookPro16,2" "MacBookPro16,3" \
  "MacPro6,1" "MacPro7,1" "Macmini6,1" "Macmini6,2" "Macmini7,1" \
  "Macmini8,1" "iMac13,1" "iMac13,2" "iMac14,1" "iMac14,2" \
  "iMac14,3" "iMac14,4" "iMac15,1" "iMac16,1" "iMac16,2" \
  "iMac17,1" "iMac18,1" "iMac18,2" "iMac18,3" "iMac19,1" \
  "iMac19,2" "iMac20,1" "iMac20,2" "iMacPro1,1"
)

declare -a BigSur=("MacBook10,1" "MacBook9,1" "MacBook8,1" "MacBookAir10,1" "MacBookAir9,1" \
    "MacBookAir8,2" "MacBookAir8,1" "MacBookAir7,2" "MacBookAir7,1" "MacBookAir6,2" \
    "MacBookAir6,1" "MacBookPro17,1" "MacBookPro16,4" "MacBookPro16,3" "MacBookPro16,2" \
    "MacBookPro16,1" "MacBookPro15,4" "MacBookPro15,3" "MacBookPro15,2" "MacBookPro15,1" \
    "MacBookPro14,3" "MacBookPro14,2" "MacBookPro14,1" "MacBookPro13,3" "MacBookPro13,2" \
    "MacBookPro13,1" "MacBookPro11,5" "MacBookPro11,4" "MacBookPro12,1" "MacBookPro11,3" \
    "MacBookPro11,2" "MacBookPro11,1" "Macmini9,1" "Macmini8,1" "Macmini7,1" \
    "iMac21,1" "iMac20,2" "iMac20,1" "iMac19,2" "iMac19,1" \
    "iMac18,3" "iMac18,2" "iMac18,1" "iMac17,1" "iMac16,2" \
    "iMac16,1" "iMac15,1" "iMac14,4" "iMacPro1,1" "MacPro7,1" \
    "MacPro6,1" "MacBookPro18,4" "MacBookPro18,3" "MacBookPro18,2" "MacBookPro18,1" \
    "MacBookPro17,1" "MacBookAir10,1" "Macmini9,1" "iMac21,2"
)

declare -a Monterey=("Mac13,2" "Mac13,1" "MacBook10,1" "MacBook9,1" "Mac14,2" \
    "MacBookAir10,1" "MacBookAir9,1" "MacBookAir8,2" "MacBookAir8,1" "MacBookAir7,2" \
    "MacBookAir7,1" "Mac14,7" "MacBookPro18,4" "MacBookPro18,3" "MacBookPro18,2" \
    "MacBookPro18,1" "MacBookPro17,1" "MacBookPro16,4" "MacBookPro16,3" "MacBookPro16,2" \
    "MacBookPro16,1" "MacBookPro15,4" "MacBookPro15,3" "MacBookPro15,2" "MacBookPro15,1" \
    "MacBookPro14,3" "MacBookPro14,2" "MacBookPro14,1" "MacBookPro13,3" "MacBookPro13,2" \
    "MacBookPro13,1" "MacBookPro12,1" "MacBookPro11,5" "MacBookPro11,4" "Macmini9,1" \
    "Macmini8,1" "Macmini7,1" "iMac21,2" "iMac21,1" "iMac20,2" \
    "iMac20,1" "iMac19,2" "iMac19,1" "iMac18,3" "iMac18,2" \
    "iMac18,1" "iMac17,1" "iMac16,2" "iMac16,1" "iMacPro1,1" \
    "MacPro7,1" "MacPro6,1")

declare -a Ventura=("Mac14,10" "Mac14,9" "Mac14,7" "Mac14,6" "Mac14,5" \
    "MacBookPro18,4" "MacBookPro18,3" "MacBookPro18,2" "MacBookPro18,1" "MacBookPro17,1" \
    "MacBookPro16,4" "MacBookPro16,3" "MacBookPro16,2" "MacBookPro16,1" "MacBookPro15,4" \
    "MacBookPro15,3" "MacBookPro15,2" "MacBookPro15,1" "MacBookPro14,3" "MacBookPro14,2" \
    "MacBookPro14,1" "Mac14,2" "MacBookAir10,1" "MacBookAir9,1" "MacBookAir8,2" \
    "MacBookAir8,1" "MacBook10,1" "iMacPro1,1" "iMac21,2" "iMac21,1" \
    "iMac20,2" "iMac20,1" "iMac19,2" "iMac19,1" "iMac18,3" \
    "iMac18,2" "iMac18,1" "Mac14,3" "Mac14,12" "Macmini9,1" \
    "Macmini8,1" "Mac13,2" "Mac13,1" "MacPro7,1" "Mac14,14" \
    "Mac14,13" "Mac14,8" "Mac14,15")

declare -a Sonoma=("Mac15,11" "Mac15,10" "Mac15,9" "Mac15,8" "Mac15,7" \
    "Mac15,6" "Mac15,3" "Mac14,10" "Mac14,9" "Mac14,7" \
    "Mac14,6" "Mac14,5" "MacBookPro18,4" "MacBookPro18,3" "MacBookPro18,2" \
    "MacBookPro18,1" "MacBookPro17,1" "MacBookPro16,4" "MacBookPro16,3" "MacBookPro16,2" \
    "MacBookPro16,1" "MacBookPro15,4" "MacBookPro15,3" "MacBookPro15,2" "MacBookPro15,1" \
    "Mac15,12" "Mac14,15" "Mac14,2" "MacBookAir10,1" "MacBookAir9,1" \
    "MacBookAir8,2" "MacBookAir8,1" "iMacPro1,1" "Mac15,5" "Mac15,4" \
    "iMac21,2" "iMac21,1" "iMac20,2" "iMac20,1" "iMac19,2" \
    "iMac19,1" "Mac14,3" "Mac14,12" "Macmini9,1" "Macmini8,1" \
    "Mac14,14" "Mac14,13" "Mac13,2" "Mac13,1" "Mac14,8" \
    "MacPro7,1" "Mac15,13")

declare -a Sequoia=("Mac16,8" "Mac16,7" "Mac16,6" "Mac16,5" "Mac16,1" \
    "Mac15,11" "Mac15,10" "Mac15,9" "Mac15,8" "Mac15,7" \
    "Mac15,6" "Mac15,3" "Mac14,10" "Mac14,9" "Mac14,7" \
    "Mac14,6" "Mac14,5" "MacBookPro18,4" "MacBookPro18,3" "MacBookPro18,2" \
    "MacBookPro18,1" "MacBookPro17,1" "MacBookPro16,4" "MacBookPro16,3" "MacBookPro16,2" \
    "MacBookPro16,1" "MacBookPro15,4" "MacBookPro15,2" "MacBookPro15,1" "Mac16,13" \
    "Mac16,12" "Mac15,13" "Mac15,12" "Mac14,15" "Mac14,2" \
    "MacBookAir10,1" "MacBookAir9,1" "iMacPro1,1" "Mac16,3" "Mac15,5" \
    "iMac21,2" "iMac21,1" "iMac20,2" "iMac20,1" "iMac19,2" \
    "iMac19,1" "Mac16,15" "Mac16,11" "Mac16,10" "Mac14,3" \
    "Mac14,12" "Macmini9,1" "Macmini8,1" "Mac16,9" "Mac15,14" \
    "Mac14,14" "Mac14,13" "Mac13,2" "Mac13,1" "Mac14,8" \
    "MacPro7,1")

# Get the internal disk
get_internal_disk() {
    echo "==== detecting internal disks ===="
    INTERNAL_DISKS=($(diskutil list internal physical | awk '/^\/dev\// && !/disk[0-9]s[0-9]/ {print $1}'))

    if [ ${#INTERNAL_DISKS[@]} -eq 0 ]; then
        echo "No internal disks found! Exiting..."
        exit 1
    elif [ ${#INTERNAL_DISKS[@]} -eq 1 ]; then
        INTERNAL_DISK=${INTERNAL_DISKS[0]}
    else
        echo "Multiple internal disks detected:"
        for i in "${!INTERNAL_DISKS[@]}"; do
            echo "$((i+1)). ${INTERNAL_DISKS[i]}"
        done
        read -p "Select a disk number to format: " disk_choice
        while ! [[ "$disk_choice" =~ ^[1-${#INTERNAL_DISKS[@]}]$ ]]; do
            echo "Invalid selection. Choose a number between 1 and ${#INTERNAL_DISKS[@]}."
            read -p "Select a disk number to format: " disk_choice
        done
        INTERNAL_DISK=${INTERNAL_DISKS[disk_choice-1]}
    fi

    echo "Selected disk: $INTERNAL_DISK"
    echo
}


# Format the disk
format_disk() {
    echo "==== formatting disk ===="

    diskutil unmountDisk force "$INTERNAL_DISK"
    diskutil eraseDisk APFS "$INTERNAL_VOLUME_NAME" "$INTERNAL_DISK"

    echo ""
}

# Perform SMC reset and NVRAM clear
clear_smcnvram() {
    echo "==== resetting SMC and clearing NVRAM ===="
    pmset -a restoredefaults && nvram -c
    echo ""
}

# Check for an internet connection
check_internet() {
    echo "Checking for internet connection...."
    while ! ping -c 1 -t 5 1.1.1.1 >/dev/null 2>&1; do
        echo "No internet connection detected."
        read -n 1 -s -r -p "Please connect to the internet then press enter: "
    done
    echo "Internet connection detected."
    echo ""
}

# Perform ASR restore
run_asr_restore() {
    local source_image=$1
    if asr restore -s "$source_image" -t "$INTERNAL_VOLUME_PATH" --erase --noverify --noprompt; then
        echo "ASR restore successful. restarting..."
        restart_system
    else
        echo "ASR restore failed! Please check the source image and try again."
    fi
}

# Perform install through application
run_application_install() {
    local installer_path="$1"

    clear_smcnvram

    echo "Starting application install"
    "$INSTALLER_VOLUME_PATH$installer_path/Contents/Resources/startosinstall" --agreetolicense --volume "$INTERNAL_VOLUME_PATH"
}

alt_run_application_install(){
    local alt_installer_path="$1"

    clear_smcnvram

    echo "Starting application install"
	"$alt_installer_path/Contents/Resources/startosinstall" --agreetolicense --volume "$INTERNAL_VOLUME_PATH"
}

# Determine partition scheme for ES
get_elevated_security() {
	if test -e "/Volumes/e/cat.dmg"; then
		echo "Legacy partition scheme found"
		alt_elevated_security
	elif test -e "/Volumes/ASR/cat.dmg"; then
		echo "Device Link partition scheme found"
		elevated_security
	else
		echo "Could not determine partition scheme for ES script!"
	fi	
}

# Elevated Security
elevated_security() {
    check_internet
    format_disk
    run_asr_restore "$ES_SOURCE_PATH"
}
# Alt. Elevated Security for legacy partition scheme
alt_elevated_security() {
	check_internet
	format_disk
	run_asr_restore "$ALT_ES_SOURCE_PATH"
	}
	
# Prompt for OS selection
select_os() {
    
    echo 
    echo "Please choose your OS:"
    for key in $(echo ${!os_names[@]} | tr ' ' '\n' | sort -n); do
        echo "$key: ${os_names[$key]}"
    done
    read userOS
    
    while ! [[ "$userOS" =~ ^[1-6]$ ]]; do
        echo "Invalid selection. Please enter a number from 1 to ${#os_names[@]}."
        read userOS
    done
}

alt_select_os() {
    
    echo 
    echo "Please choose your OS:"
    for key in $(echo ${!alt_os_names[@]} | tr ' ' '\n' | sort -n); do
        echo "$key: ${alt_os_names[$key]}"
    done
    read userOS
    
    while ! [[ "$userOS" =~ ^[1-7]$ ]]; do
        echo "Invalid selection. Please enter a number from 1 to ${#alt_os_names[@]}."
        read userOS
    done
}

# Prompt for installation method
select_install_method() {
    if [ "$userOS" -le 5 ] ; then
        echo
        echo "Choose installation method: 1. ASR 2. application install"
        read userMethod
        while ! [[ "$userMethod" =~ ^[1-2]$ ]]; do
            echo "Invalid selection. Please enter 1 for ASR or 2 for application install."
            read userMethod
        done
    else 
        userMethod=2
    fi
	
}

# Run through a passed array of Mac devices to see if our device is included in that version array
hasVersion() {
    local needle model_list
    needle=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')   # lowercase search term
    shift                                                      # shift args so only array remains
    # join array, lowercase, replace newlines with spaces
    model_list=$(printf '%s\n' "$@" | tr '[:upper:]' '[:lower:]' | tr -s '\n' ' ')
    [[ " $model_list " == *" $needle "* ]]
}

get_install_os() {
    # Get device model name
    model=$(sysctl -n hw.model)
    echo
    echo "Device Model: $model"

    # Run a version compatibility check for the current device model
    if hasVersion "$model" "${Sequoia[@]}"; then printf "Sequoia: ✔ "
    else printf "Sequoia: ✖ "
    fi

    if hasVersion "$model" "${Sonoma[@]}"; then printf "Sonoma: ✔ "
    else printf "Sonoma: ✖ "
    fi

    if hasVersion "$model" "${Ventura[@]}"; then printf "Ventura: ✔ "
    else printf "Ventura: ✖ "
    fi

    if hasVersion "$model" "${Monterey[@]}"; then printf "Monterey: ✔ "
    else printf "Monterey: ✖ "
    fi

    if hasVersion "$model" "${BigSur[@]}"; then printf "Big Sur: ✔ "
    else printf "Big Sur: ✖ "
    fi

    if hasVersion "$model" "${Catalina[@]}"; then printf "Catalina: ✔\n"
    else printf "Catalina: ✖\n"
    fi
    echo
    # Determine which partition scheme we are in
	if test -e "/Volumes/e/"; then
		echo "Legacy partition scheme found"
		alt_install_os
	elif test -e "/Volumes/FULL/"; then
		echo "Device Link partition scheme found"
		install_os
	else
		echo "Could not determine partition scheme for installation script!"
	fi	
	
}

# Install macOS
install_os() {
    declare -a os_names
    os_names[1]="Tahoe"
	os_names[2]="Sequoia"
    os_names[3]="Sonoma"
    os_names[4]="Ventura"
    os_names[5]="Monterey"
    os_names[6]="Big Sur"
	
	# Create associative arrays for file paths
    declare -a asr_images
	asr_images[1]="tahoe.dmg"
    asr_images[2]="sequoia.dmg"
    asr_images[3]="sonoma.dmg"
    asr_images[4]="ventura.dmg"
    asr_images[5]="monterey.dmg"
    asr_images[6]="bigsur.dmg"
    
    declare -a installers
    installers[1]="Install macOS Tahoe.app"
	installers[2]="Install macOS Sequoia.app"
    installers[3]="Install macOS Sonoma.app"
    installers[4]="Install macOS Ventura.app"
	installers[5]="Install macOS Monterey.app"
    installers[6]="Install macOS Big Sur.app"

    
    

    select_os
    #select_install_method

    format_disk

    
    echo "==== starting OS installation ===="    


    # For Sequoia installation, check internet connection first
    if [[ "$userOS" == 1 ]]; then
        check_internet
    fi

	# Default to ASR if image exists, fallback to application otherwise
    if [ -f  "$ASR_IMAGE_PATH${asr_images[$userOS]}" ]; then
        echo "${os_names[$userOS]} ASR install"
        run_asr_restore "$ASR_IMAGE_PATH${asr_images[$userOS]}"
    elif [ -d "$INSTALLER_VOLUME_PATH${installers[$userOS]}" ]; then
        echo "${os_names[$userOS]} application install"
        run_application_install "${installers[$userOS]}"
    else
		echo "Could not find ASR image or installer application for the selected OS. Please check your drive"
		echo "ASR path: $ASR_IMAGE_PATH${asr_images[$userOS]}"
		echo "Application: $INSTALLER_VOLUME_PATH${installers[$userOS]}"
		echo
	fi
}

# Alternative installer for old usb partition scheme
alt_install_os() {
    # Create array of hardcoded dmg paths in the old usb scheme
    declare -a alt_asr_images
    alt_asr_images[1]="/Volumes/s/Sonoma.dmg"
    alt_asr_images[2]="/Volumes/v/ventura.dmg"
    alt_asr_images[3]="/Volumes/m/monterey.dmg"
    alt_asr_images[4]="/Volumes/b/bigsur.dmg"
    

    
    declare -a alt_os_names
    alt_os_names[1]="Sonoma"
    alt_os_names[2]="Ventura"
    alt_os_names[3]="Monterey"
    alt_os_names[4]="Big Sur"

	# Declared as paths since the legacy partition isnt as neat as the new one T_T
    declare -a alt_installers
    alt_installers[1]="/Volumes/Install MacOS Sonoma/Install MacOS Sonoma.app"
    alt_installers[2]="/Volumes/Install MacOS Ventura/Install macOS Ventura.app"
    alt_installers[3]="/Volumes/Install MacOS Monterey/Install macOS Monterey.app"
	alt_installers[4]="/Volumes/Install MacOS Big Sur/Install macOS Big Sur.app"


    alt_select_os
    #select_install_method

    format_disk

    
    echo "==== starting OS installation ===="    
    
    if [ -f "${alt_asr_images[$userOS]}" ]; then
        echo "${alt_os_names[$userOS]} ASR install"
        run_asr_restore "${alt_asr_images[$userOS]}"
    elif [ -f "${alt_installers[$userOS]}" ]; then
        echo "selected ${alt_os_names[$userOS]} application install"
        alt_run_application_install "${alt_installers[$userOS]}"
    fi
}

# Restart system after resetting SMC and clearing NVRAM
restart_system() {
    echo "restarting..."
    clear_smcnvram
    reboot
    
    #try harder if didn't restart after 30 seconds
    sleep 30
    echo "Attempting restart again"
    reboot -q

    exit
}

# Quit the script
quit_script() {
    echo "Exiting script..."
    userQuit=1  # Ensures the loop in main_menu exits cleanly
}

# Main Menu Function
main_menu() {
    until [ "$userQuit" = 1 ]; do
        echo 
        echo "===== macOS Installation and Recovery Tool ====="
        echo "1. Elevated Security"
        echo "2. Install OS"
        echo "3. Restart System"
        echo "4. Reset SMC and Clear NVRAM"
        echo "5. Quit"
        echo "================================================"
        read -p "Enter your choice (1-5): " userinput

        case $userinput in
            1) get_elevated_security ;;
            2) get_install_os ;;
            3) restart_system ;;
            4) clear_smcnvram ;;
            5) quit_script ;;
            *) echo "Invalid choice. Please enter a number 1-5." ;;
        esac
    done
}

# Main
get_internal_disk
main_menu

