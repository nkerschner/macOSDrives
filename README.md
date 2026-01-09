# Creating a macOS Drive
Minimum drive size required is 256GB

## Partitions

### Install macOS Big Sur
Format: Mac OS Extended (Journaled)
Size: 14 GB
Description: Bootable Big Sur installer

### Big Sur Boot
Format: APFS
Size: 32 GB
Description: Partition with Big Sur installed, which allows us to bypass Internet Recovery into the Big Sur recoveryOS

### FULL
Format: APFS
Size: 100 GB
Description: Contains the "Applications" directory where the macOS installer applications are stored

### ASR (optional)
Format: APFS
Size: 110 GB
Description: Contains the ASR images

## Using Mist for macOS installers
Mist is a helpful tool for downloading macOS Firmwares and Installers.
It can be found at: [](https://github.com/ninxsoft/Mist) 

# Running the script
Run the script from the recoveryOS terminal with the command `sh -c "$(curl -fsSL mac.nscott.xyz/go.sh)"`
