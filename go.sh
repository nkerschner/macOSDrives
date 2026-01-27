#!/bin/bash 


# macOS Installation and Elevated Security Removal Tool
# v4.0-beta
# https://github.com/nkerschner/macOSDrives


cd /
userQuit=0


# declare default paths
readonly ASR_IMAGE_PATH="/Volumes/ASR/"
readonly INSTALLER_VOLUME_PATH="/Volumes/FULL/Applications/"
readonly ES_SOURCE_PATH="/Volumes/ASR/cat.dmg"
readonly ALT_ES_SOURCE_PATH="Volumes/e/cat.dmg"
readonly INTERNAL_VOLUME_NAME="Macintosh HD"
readonly INTERNAL_VOLUME_PATH="/Volumes/Macintosh HD"
readonly REMOTE_INSTALLER_REPOSITORY="http://10.50.0.190/macos/installers/" #current testing repo, /not/ production ready
readonly REMOTE_ASR_REPOSITORY="http://10.50.0.190/macos/asr/" #current testing repo, /not/ production ready
readonly UPDATE_ZIP_TEMP_DIR="/Volumes/ASR/"

# declare array of OS names
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

declare -a remote_installers
    remote_installers[1]="Install-macOS-Tahoe.zip"
	remote_installers[2]="Install-macOS-Sequoia.zip"
    remote_installers[3]="Install-macOS-Sonoma.zip"
    remote_installers[4]="Install-macOS-Ventura.zip"
    remote_installers[5]="Install-macOS-Monterey.zip"
    remote_installers[6]="Install-macOS-Big-Sur.zip"

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

# Perform power management settings reset and NVRAM clear
clear_smcnvram() {
    echo "==== resetting power management settings and clearing NVRAM ===="
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

update_installer() {
    echo "Checking for updated installer...."
    if [ -f "$INSTALLER_VOLUME_PATH${os_names[$userOS]}.txt" ]; then
        local current_chksum=$(<"$INSTALLER_VOLUME_PATH${os_names[$userOS]}.txt")
    else
        local current_chksum="does not exist"
    fi
    local new_chksum=$(curl -s "$REMOTE_INSTALLER_REPOSITORY${os_names[$userOS]}.txt")
    echo "Current Checksum: $current_chksum"
    echo "New Checksum: $new_chksum"

    if [[ "$current_chksum" != "$new_chksum" ]] ; then
        echo "Installer update detected...."
        
        echo "Downloading $REMOTE_INSTALLER_REPOSITORY${remote_installers[$userOS]} to $UPDATE_ZIP_TEMP_DIR${remote_installers[$userOS]}...."
        if ! curl "$REMOTE_INSTALLER_REPOSITORY${remote_installers[$userOS]}" --output "$UPDATE_ZIP_TEMP_DIR${remote_installers[$userOS]}" ; then
            echo "Error downloading updated installer, exiting...."
            return 1
        fi

        echo "Extracting new installer...."
        if ! unzip -o "$UPDATE_ZIP_TEMP_DIR${remote_installers[$userOS]}" -d "$INSTALLER_VOLUME_PATH" ; then
            echo "Error extracting new installer, exiting...."
            return 1
        fi

        echo "Updating installer checksum...."
        if ! curl "$REMOTE_INSTALLER_REPOSITORY${os_names[$userOS]}.txt" --output "$INSTALLER_VOLUME_PATH${os_names[$userOS]}.txt" ; then
            echo "Error downloading updated checksum, exiting...."
            return 1
        fi

        echo "Cleaning up...."
        if ! rm "$UPDATE_ZIP_TEMP_DIR${remote_installers[$userOS]}" ; then
            echo "Error removing temporary installer zip file, may need to manually remove...."
        fi
    else
        echo "Latest installer detected on USB...."
    fi
}

update_image() {
    echo "Checking for updated image...."
    if [ -f "$ASR_IMAGE_PATH${os_names[$userOS]}.txt" ]; then
        local current_chksum=$(<"$ASR_IMAGE_PATH${os_names[$userOS]}.txt")
    else
        local current_chksum="does not exist"
    fi
    local new_chksum=$(curl -s "$REMOTE_ASR_REPOSITORY${os_names[$userOS]}.txt")
    echo "Current Checksum: $current_chksum"
    echo "New Checksum: $new_chksum"

    if [[ "$current_chksum" != "$new_chksum" ]] ; then
        echo "Image update detected...."
        
        echo "Downloading $REMOTE_ASR_REPOSITORY${asr_images[$userOS]} to $ASR_IMAGE_PATH${asr_images[$userOS]}...."
        if ! curl "$REMOTE_ASR_REPOSITORY${asr_images[$userOS]}" --output "$ASR_IMAGE_PATH${asr_images[$userOS]}" ; then
            echo "Error downloading updated installer, exiting...."
            return 1
        fi

        echo "Updating installer checksum...."
        if ! curl "$REMOTE_INSTALLER_REPOSITORY${os_names[$userOS]}.txt" --output "$INSTALLER_VOLUME_PATH${os_names[$userOS]}.txt" ; then
            echo "Error downloading updated checksum, exiting...."
            return 1
        fi
    else
        echo "Latest image detected on USB...."
    fi
}

# Perform ASR restore
run_asr_restore() {
    local source_image=$1
    "==== starting ASR restore of $source_image ===="
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

    update_installer

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

get_install_os() {
    curl -fsSL https://raw.githubusercontent.com/nkerschner/macOSDrives/refs/heads/Auto_installer_update/compatible_os.sh -o /tmp/compatible_os.sh
    source /tmp/compatible_os.sh
	
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

test_installer_update() {  
    select_os
    update_installer "${installers[$userOS]}"
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
    elif [ -d "${alt_installers[$userOS]}" ]; then
        echo "selected ${alt_os_names[$userOS]} application install"
        alt_run_application_install "${alt_installers[$userOS]}"
    fi
}

# Scan ASR image
ASR_image_scan() { 
	echo "Please select the image you would like to scan: "
	select_os

	echo "Starting scan of $ASR_IMAGE_PATH${asr_images[$userOS]}"
    if asr imagescan -s "$ASR_IMAGE_PATH${asr_images[$userOS]}" &> /dev/null; then
        echo "ASR image scan successful."
    else
        echo "ASR image scan failed"
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
        echo "1. Restore to Elevated Security Removal image"
        echo "2. Install OS"
        echo "3. Scan ASR image"
        echo "4. Restart System"
        echo "5. Reset Power Management Settings and Clear NVRAM"
        echo "6. Test Installer Update"
        echo "7. Quit"
        echo "================================================"
        read -p "Enter your choice (1-7): " userinput

        case $userinput in
            1) get_elevated_security ;;
            2) get_install_os ;;
            3) ASR_image_scan ;;
            4) restart_system ;;
            5) clear_smcnvram ;;
            6) test_installer_update ;;
            7) quit_script ;;
            *) echo "Invalid choice. Please enter a number 1-7." ;;
        esac
    done
}

# Main
get_internal_disk
main_menu

