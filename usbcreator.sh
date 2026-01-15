#!/bin/bash 

readonly application_repo="http://10.50.0.190/macos/installers/"
readonly applications_dir="/Volumes/Full/Applications/"
readonly temp_dir="/Volumes/ASR/"
declare -a installers=("Install-macOS-Tahoe.zip" "Install-macOS-Sequoia.zip" "Install-macOS-Sonoma.zip" "Install-macOS-Big-Sur.zip")

readonly asr_repo="http://10.50.0.190/macos/asr/"
readonly asr_dir="/Volumes/ASR/"
declare -a asr_images=("bigsur.dmg" "cat.dmg" "monterey.dmg" "ventura.dmg")

get_external_disk() {
    echo "==== detecting external disks ===="
    EXTERNAL_DISKS=($(diskutil list external physical | awk '/^\/dev\// && !/disk[0-9]s[0-9]/ {print $1}'))

    if [ ${#EXTERNAL_DISKS[@]} -eq 0 ]; then
        echo "No external disks found! Exiting..."
        exit 1
    elif [ ${#EXTERNAL_DISKS[@]} -eq 1 ]; then
        macOSDrive=${EXTERNAL_DISKS[0]}
    else
        echo "Multiple external disks detected:"
        for i in "${!EXTERNAL_DISKS[@]}"; do
            echo "$((i+1)). ${EXTERNAL_DISKS[i]}"
        done
        read -p "Select a disk number to format: " disk_choice
        while ! [[ "$disk_choice" =~ ^[1-${#EXTERNAL_DISKS[@]}]$ ]]; do
            echo "Invalid selection. Choose a number between 1 and ${#EXTERNAL_DISKS[@]}."
            read -p "Select a disk number to format: " disk_choice
        done
        macOSDrive=${EXTERNAL_DISKS[disk_choice-1]}
    fi

    echo "Selected disk: $macOSDrive"
    echo
}

format_drive(){
    diskutil partitionDisk $macOSDrive 4 APFS FULL 100G \
        JHFS+ BigSur 14G \
        APFS Boot 32G \
        APFS ASR 100G
    mkdir $applications_dir
}

download_installers(){
    for i in "${!installers[@]}"; do
        curl $application_repo${installers[i]} -o $temp_dir${installers[i]}
        unzip $temp_dir${installers[i]} -d $applications_dir
        rm $temp_dir${installers[i]}
    done
}

download_asr_images(){
    for i in "${!asr_images[@]}"; do
        curl $asr_repo${asr_images[i]} -o $asr_dir${asr_images[i]}
    done
}

create_big_sur_installer(){
    #$applications_dir
    echo "working on it lol"
}

install_to_boot(){
    echo "working on this too lol"
}

get_external_disk
format_drive
download_installers
download_asr_images
create_big_sur_installer
install_to_boot
