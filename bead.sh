#!/bin/bash
mount_usb() {
    diskutil mount "$(diskutil list | grep -i blancco | awk '{print $NF}')"
}

eject_usb() {
    diskutil eject /Volumes/BLANCCO
}

copy_agent_from_usb() {
    if cp -R "/Volumes/BLANCCO/BEAD Agent" /Users/Shared/; then
        echo "Successfully copied BEAD Agent files"
    else
    echo "Could not copy necessary files. Exiting..."
        exit 1
    fi
}

get_bead_host() {
    read -p "Enter the user and IP of your BEAD Host (e.g. example@127.0.0.1): " BEAD_HOST
}

copy_agent_from_host() {
    if scp -o StrictHostKeyChecking=no -r $BEAD_HOST:~/Desktop/Bead\ Agent /Users/shared/; then
        echo "successfully copied BEAD Agent files"
    else
        echo "Could not copy necessary files. Exiting..."
        exit 1
    fi
}

open_agent() {
    echo "Opening BEAD Agent"
    open -a "BEAD Agent"

    # Check if BEAD Agent was succesfully opened, otherwise try to start from the copied directory, or fallback to a Finder window
    # First check if the -a flag opened BEAD Agent
    if pgrep -q "BEAD Agent"; then
        echo "BEAD Agent succesfully started!"
    else
        # Next try opening by pointing to the .app in the copied directory
        open /Users/Shared/BEAD\ Agent/Bead\ Agent.app
        
        if pgrep -q "BEAD Agent"; then
            echo "BEAD Agent succesfully started!"
        else
            echo "Can't find BEAD Agent window! Please start the application manually."
            # Finally, fall back to opening Finder for a manual start
            open "/Users/Shared"
        fi
    fi
}

clean_up() {
    read -p "Once finished with diagnostic testing, press enter to remove the files: " removeFiles
    rm -rf "/Users/Shared/Bead Agent"
}

# Opens Photo Booth to prime the webcam for BEAD Agent testing
prep_webcam() {
    echo "Preparing webcam for testing."
    open -a "Photo Booth"
    # sleep 5
    # killall -9 "Photo Booth"
}

# Main
if mount_usb; then
    echo "Copying BEAD Agent from USB..."
    copy_agent_from_usb
    eject_usb
else
    echo "No USB present, BEAD Agent must be fetched from BEAD Host."
    get_bead_host
    copy_agent_from_host
fi

prep_webcam
open_agent
clean_up
