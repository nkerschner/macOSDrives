#!/bin/bash 

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

    # Run through a passed array of Mac devices to see if our device is included in that version array
hasVersion() {
    local needle model_list
    needle=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')   # lowercase search term
    shift                                                      # shift args so only array remains
    # join array, lowercase, replace newlines with spaces
    model_list=$(printf '%s\n' "$@" | tr '[:upper:]' '[:lower:]' | tr -s '\n' ' ')
    [[ " $model_list " == *" $needle "* ]]
}

list_compatible_os() {
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

}