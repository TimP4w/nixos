#!/usr/bin/env bash

set -e

######################### VARS ###############################
USER=$(whoami)

# Constants (these shouldn't change!)
WINEASIOPATH="/nix/store/v2r937mrln65z0dah62a8jqs6n13yrzx-wineasio-1.2.0/lib/wine" 
#WINEASIOPATH="/lib/wine" 
WINEASIODLLS=(
    "/i386-unix/wineasio32.dll.so" 
    "/i386-windows/wineasio32.dll" 
    "/x86_64-unix/wineasio64.dll.so" 
    "/x86_64-windows/wineasio64.dll"
)
STEAMPATH="/home/${USER}/.steam/steam"
WINEPREFIX="${STEAMPATH}/steamapps/compatdata/221680/pfx/"
#WINEPREFIX="/home/${USER}/.wine/"

LAUNCH_OPTIONS="LD_PRELOAD=/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%"
      # LD_PRELOAD=/nix/store/l591nwchhgrm8lnzqrxfjvp1zzdp4jyc-pipewire-1.2.6-jack/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%

# Defaults
RSASIOVER="0.7.1"
PROTONVER="Proton - Experimental" 
FILES_OR_DIST="files"
PROTONPATH="${STEAMPATH}/steamapps/common/${PROTONVER}"
WINE="${PROTONPATH}/${FILES_OR_DIST}/bin/wine"
WINE64="${PROTONPATH}/${FILES_OR_DIST}/bin/wine64"

#############################################################
print_color() {
    local COLOR=$1
    local NC='\033[0m'
    echo -e "${COLOR}$2${NC}"
}

print_blue() {
    local BLUE='\033[0;34m'
    print_color $BLUE "$1"
}

print_green() {
    local GREEN='\033[0;32m'
    print_color $GREEN "$1"
}

print_red() {
    local RED='\033[0;31m'
    print_color $RED "$1"
}

print_orange() {
    local ORANGE='\033[38;5;214m'  
    print_color $ORANGE "$1"
}

validate_proton_input() {
    if [[ -z $1 || $1 =~ ^[0-2]$ ]]; then
        return 0
    else
        return 1
    fi
}

choose_proton() {
    echo "Please choose your proton version that you use to run Rocksmith:"
    print_orange "0) Proton - Experimental [Default]"
    echo "1) Proton 9.0 (Beta)"
    echo "2) Proton 8.0"

    read -p "Choose your Proton Version (0-2): " USERPROTONVER

    if validate_proton_input "$USERPROTONVER"; then
         case $USERPROTONVER in
            0)
                PROTONVER="Proton - Experimental"
                FILES_OR_DIST="files"
                ;;
            1)
                PROTONVER="Proton 9.0"
                FILES_OR_DIST="files"  
                ;;
            2)
                PROTONVER="Proton 8.0"
                FILES_OR_DIST="dist"
                ;;
        esac

        PROTONPATH="${STEAMPATH}/steamapps/common/${PROTONVER}"
        WINE="${PROTONPATH}/${FILES_OR_DIST}/bin/wine"
        WINE64="${PROTONPATH}/${FILES_OR_DIST}/bin/wine64"

        print_blue "Using $PROTONVER"
    else
        print_red "You need to select a value between 0 and 2, please try again"
        choose_proton
    fi
}

validate_rsasio_input() {
    if [[ -z $1 || $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

choose_rsasio() {
    read -p "Override RS_ASIO Version [$(print_orange ${RSASIOVER})]: " USER_RSASIOVER
    if validate_rsasio_input "$USER_RSASIOVER"; then
        RSASIOVER=${USER_RSASIOVER:-$RSASIOVER}
        print_blue "Using $RSASIOVER"
    else
        print_red "The value is not in the correct format: x.y.z"
        choose_rsasio
    fi
}

greet() {
    print_blue "======== Rocksmith 2014 - Wineasio patcher for NixOS ========"

    choose_proton

    choose_rsasio
}

print_system_info() {
    print_blue "======== System Info "========
    echo "NixOS $(nixos-version) [$(getconf LONG_BIT)-bit]"
    echo "Kernel $(uname -r)"
    echo "Wine $("${WINE}" --version)"
    echo "Wine64 $("${WINE64}" --version)"

    echo "RS_ASIO (Desired) ${RSASIOVER}"
    echo "Proton (Desired) ${PROTONVER}"
}

check_installed() {
    if which $1 >/dev/null 2>&1; then
        echo "$1 $(print_green present)"
    else
        print_red "Required $1 is not installed!"
        exit 1
    fi
}


check_and_prepare() {
    print_blue "======== Check and prepare "========
    check_passed=true

    CHECKPATHS=(
        "$WINEPREFIX"
        "$WINEASIOPATH"
        "$STEAMPATH"
        "$PROTONPATH"
        "/lib/wine"
        "${STEAMPATH}/steamapps/compatdata/221680" 
        "${STEAMPATH}/steamapps/compatdata/221680/pfx/"
    )

    CHECKFILES=(
        "$WINE"
        "$WINE64"
        "/lib/libjack.so"

        "./config/Rocksmith.ini"
        "./config/RS_ASIO.ini"
        "./cdlc/D3DX9_42.dll"
        "./cdlc/xinput1_3.dll"
    )

    CHECKPROGRAMS=(
        "steam"
        "steam-run"
        "pipewire"
    )

    echo "=== Paths ==="


    for path in "${CHECKPATHS[@]}"; do
        if [ ! -d "${path}" ]; then
            echo "Directory ${path} ... $(print_red "NOT Found!")"
            check_passed=false
        else
            echo "Directory ${path} ... $(print_green OK)"
        fi
    done

    echo "=== Files ==="


    for file in "${CHECKFILES[@]}"; do
        if [ ! -f "${file}" ]; then
            echo "File ${file} ... $(print_red "NOT Found!")"
            check_passed=false
        else 
            echo "File ${file} ... $(print_green OK)"
        fi
    done

    for dll in "${WINEASIODLLS[@]}"; do
        if [ ! -f "${WINEASIOPATH}${dll}" ]; then
            echo "File "${WINEASIOPATH}${dll}"... $(print_red "Not Found!")"
            check_passed=false

        else 
            echo "File "${WINEASIOPATH}${dll}" ... $(print_green OK)"
        fi
    done

    for program in "${CHECKPROGRAMS[@]}"; do
        check_installed $program
    done

    if [ "$check_passed" = false ]; then
        print_red "A check failed. Exiting the program."
        exit 1
    fi

    read -p "This script will add wineasio to proton and Rocksmith, register it and install RS_ASIO. Do you want to continue? (Y/N): " user_input
    user_input=$(echo "$user_input" | tr '[:lower:]' '[:upper:]')
    if [ "$user_input" != "Y" ]; then
        print_red "Exiting..."
        exit 0
    fi
}

register_dll() {
    echo "[Wineasio] Registering ${1}"
    "${2}" regsvr32 "${1}" > /dev/null 2>&1
}

safe_copy() {
    echo "[COPY FILE] $1 -> $2"
    rm -rf "$2"
    cp "$1" "$2"
}

patch_wineasio_32bit() {
    echo "[Wineasio] Applying Patch for 32-bit"
    safe_copy "${WINEASIOPATH}${1}" "${PROTONPATH}/${FILES_OR_DIST}/lib/wine${1}"
    if [[ $1 == *.so ]]; then
        local wineasio_dll=$(echo ${WINEASIOPATH}${1} | sed -e 's|/i386-unix/wineasio32.dll.so|/i386-windows/wineasio32.dll|g')
        if [ -e "${WINEASIOPATH}${1}" ] && [ -e "${wineasio_dll}" ]; then
            echo "[Wineasio 32-bit] Copying ${wineasio_dll} in ${WINEPREFIX}/drive_c/windows/syswow64/wineasio32.dll"
            safe_copy "${wineasio_dll}" "${WINEPREFIX}/drive_c/windows/syswow64/wineasio32.dll"
            register_dll "$wineasio_dll" "$WINE"
        fi
    fi
}

patch_wineasio_64bit() {
    echo "[Wineasio] Applying Patch for 64-bit"

    safe_copy "${WINEASIOPATH}${1}" "${PROTONPATH}/${FILES_OR_DIST}/lib64/wine${1}"

    if [[ $1 == *.so ]]; then
        if [ ! -d "${WINEPREFIX}/drive_c/windows/syswow64" ]; then
            echo "[Wineasio] Skipping $1 because ${WINEPREFIX} is not a 64-bit system"
            continue 
        fi
        local wineasio_dll=$(echo ${WINEASIOPATH}${1} | sed -e 's|/x86_64-unix/wineasio64.dll.so|/x86_64-windows/wineasio64.dll|g')
        if [ -e "${WINEASIOPATH}${1}" ] && [ -e "${wineasio_dll}" ]; then
            echo "[Wineasio 64-bit] Copying ${wineasio_dll} in ${WINEPREFIX}/drive_c/windows/system32/wineasio64.dll"
            safe_copy "${wineasio_dll}" "${WINEPREFIX}/drive_c/windows/system32/wineasio64.dll"
            register_dll "$wineasio_dll" "$WINE64"
        fi
    fi
}

patch_wineasio() {
    print_blue "======== Wineasio ========"
    echo "[Wineasio] Install Wineasio"

    for dll in "${WINEASIODLLS[@]}"; do
        if echo "$dll" | grep -q "32"; then
            patch_wineasio_32bit "$dll"
        elif echo "$dll" | grep -q "64"; then
            patch_wineasio_64bit "$dll"
        else
            echo "$dll doesn't contain 32 or 64 in its name. Can't choose if 32 or 64 bit."
        fi
    done
}

patch_rs_asio() {
    print_blue "======== RS_ASIO ========"

    echo "[RS_ASIO] Dowload RS_ASIO"
    if [ ! -f "release-${RSASIOVER}.zip" ]; then
        wget https://github.com/mdias/rs_asio/releases/download/v${RSASIOVER}/release-${RSASIOVER}.zip > /dev/null 2>&1
    fi

    echo "[RS_ASIO] Unzip"
    unzip release-${RSASIOVER}.zip -d RS_ASIO

    sed -i 's/Driver=[^ ]*/Driver=wineasio-rsasio/g' "RS_ASIO/RS_ASIO.ini"

    echo "[RS_ASIO] Copying RS_ASIO to Rocksmith installation"
    cp -a "RS_ASIO/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}

add_configs() {
    print_blue "======== CONFIGURATION ========"
    echo "[CONF] Copy configs"
    cp -a "config/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}

patch_cdlc() {
    print_blue "======== CDLCs ========"
    echo "[CDLC] Install CDLC Patch"
    cp -a "cdlc/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}



finalise() {
    print_blue "======== DONE ========"

    echo "Patch applied, you can now configure Rocksmith"

    echo "First, check that the RS_ASIO.ini file is correct"
    echo
    echo "Finally, add the following launch option to Rocksmith on steam"
    echo 
    echo "================================================================"
    echo $LAUNCH_OPTIONS
    echo "================================================================"
}


################### Execute ################### 
greet
print_system_info
check_and_prepare
patch_wineasio
patch_rs_asio
add_configs
patch_cdlc
finalise
