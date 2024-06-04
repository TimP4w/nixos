#!/usr/bin/env bash

set -e

######################### VARS ###############################
USER=$(whoami)

PROTONVER="Proton - Experimental"
RSASIOVER="0.7.1"

STEAMPATH="/home/${USER}/.steam/steam"
PROTONPATH="${STEAMPATH}/steamapps/common/${PROTONVER}"
WINE="${PROTONPATH}/files/bin/wine"
WINE64="${PROTONPATH}/files/bin/wine64"
WINEPREFIX="${STEAMPATH}/steamapps/compatdata/221680/pfx/"

LAUNCH_OPTIONS="LD_PRELOAD=/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%"


# Constants (these shouldn't change!)
WINEASIOPATH="/lib/wine" 
WINEASIODLLS=(
    "/i386-unix/wineasio32.dll.so" 
    "/i386-windows/wineasio32.dll" 
    "/x86_64-unix/wineasio64.dll.so" 
    "/x86_64-windows/wineasio64.dll"
)

#############################################################
print_blue() {
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
    echo -e "${BLUE}$1${NC}"
}
print_green() {
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}$1${NC}"
}

print_red() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e "${RED}$1${NC}"
}

greet() {
    print_blue "======== Rocksmith 2014 - Wineasio patcher for NixOS ========"

    read -p "Override Proton Version [${PROTONVER}]: " USER_PROTONVER
    PROTONVER=${USER_PROTONVER:-$PROTONVER}

    read -p "Override RS_ASIO Version [${RSASIOVER}]: " USER_RSASIOVER
    RSASIOVER=${USER_RSASIOVER:-$RSASIOVER}
}

backup() {
    echo "Bacukp..."
    ## TODO: make backup before doing stuff
}

print_system_info() {
    print_blue "======== System Info "========
    echo "NixOS $(nixos-version) [$(getconf LONG_BIT)-bit]"
    echo "Kernel $(uname -r)"
    echo "Wine $("${WINE}" --version)"
    echo "Wine64 $("${WINE64}" --version)"
    #echo "Wineasio $(basename "$LD_WINEASIO_PATH" | sed 's/^[^-]*-//')"
    #echo "Pipewire Jack $(basename "$LD_PIPEWIRE_JACK_PATH" | sed 's/^[^-]*-//')"
    echo "RS_ASIO (Desired) ${RSASIOVER}"
    echo "Proton (Desired) ${PROTONVER}"

    echo "Before starting, add the cdlcs dlls (D3DX9_42.dll & xinput1_3.dll) in the cdlc directory"
    read -p "Do you want to continue? (Y/N): " user_input
    user_input=$(echo "$user_input" | tr '[:lower:]' '[:upper:]')
    if [ "$user_input" != "Y" ]; then
        echo "Exiting..."
        exit 0
    fi
}

check_installed() {
    if which $1 >/dev/null 2>&1; then
        echo "$1 present"
    else
        echo "Required $1 is not installed!"
        exit 1
    fi
}


prepare() {
    print_blue "======== Check and prepare "========
    check_passed=true
    ## Create .wine dir
    #rm -rf $WINEPREFIX
    #mkdir $WINEPREFIX

    CHECKPATHS=(
        "$WINEPREFIX"
        "$WINEASIOPATH"
        "$STEAMPATH"
        "$PROTONPATH"
        "/lib/wine"
        #"$LD_PIPEWIRE_JACK_PATH"
        #"$LD_WINEASIO_PATH"
        "${STEAMPATH}/steamapps/compatdata/221680" 
        "${STEAMPATH}/steamapps/compatdata/221680/pfx/"
    )

    CHECKFILES=(
        "$WINE"
        "$WINE64"
        "./config/Rocksmith.ini"
        "./config/RS_ASIO.ini"
        "./cdlc/D3DX9_42.dll"
        "./cdlc/xinput1_3.dll"
        "/lib/libjack.so"
    )

    CHECKPROGRAMS=(
        "steam"
        "steam-run"
        "pipewire"
    )

    echo "=== Paths ==="


    for path in "${CHECKPATHS[@]}"; do
        if [ ! -d "${path}" ]; then
            echo "Directory ${path} ... $(print_red NOT found!)"
            check_passed=false
        else
            echo "Directory ${path} ... $(print_green OK)"
        fi
    done

    echo "=== Files ==="


    for file in "${CHECKFILES[@]}"; do
        if [ ! -f "${file}" ]; then
            echo "File ${file} ... $(print_red NOT found!)"
            check_passed=false
        else 
            echo "File ${file} ... $(print_green OK)"
        fi
    done

    for dll in "${WINEASIODLLS[@]}"; do
        if [ ! -f "${WINEASIOPATH}${dll}" ]; then
            echo "File ${dll} ... $(print_red NOT found!)"
            check_passed=false

        else 
            echo "File ${dll} ... $(print_green OK)"
        fi
    done

    for program in "${CHECKPROGRAMS[@]}"; do
        check_installed $program
    done

    if [ "$check_passed" = false ]; then
        print_red "A check failed. Exiting the program."
        exit 1
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
    safe_copy "${WINEASIOPATH}${1}" "${PROTONPATH}/files/lib/wine${1}"
    # TODO: We assume it's a 64-bit system. Shouldn't change in the future, but do we want to add a test like for 64-bit?
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

    safe_copy "${WINEASIOPATH}${1}" "${PROTONPATH}/files/lib64/wine${1}"

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

    #echo "Copying ${STEAMPATH}/steamapps/compatdata/221680/pfx/* --> ${WINEPREFIX}/"
    #cp -a -r "${STEAMPATH}/steamapps/compatdata/221680/pfx/"* "${WINEPREFIX}/"

    for dll in "${WINEASIODLLS[@]}"; do
        if echo "$dll" | grep -q "32"; then
            patch_wineasio_32bit "$dll"
        elif echo "$dll" | grep -q "64"; then
            patch_wineasio_64bit "$dll"
        else
            echo "$dll doesn't contain 32 or 64 in its name. Can't choose if 32 or 64 bit."
        fi
    done

    ### Copy patched wineprefix back
    #rm -rf ${STEAMPATH}/steamapps/compatdata/221680/pfx
    #mkdir ${STEAMPATH}/steamapps/compatdata/221680/pfx
    #cp -a -r "${WINEPREFIX}/"* "${STEAMPATH}/steamapps/compatdata/221680/pfx/"
}

patch_rs_asio() {
    print_blue "======== RS_ASIO ========"

    echo "[RS_ASIO] Dowload RS_ASIO"
    if [ ! -f "release-${RSASIOVER}.zip" ]; then
        wget https://github.com/mdias/rs_asio/releases/download/v${RSASIOVER}/release-${RSASIOVER}.zip > /dev/null 2>&1
    fi

    echo "[RS_ASIO] Unzip"
    unzip release-${RSASIOVER}.zip -d RS_ASIO

    echo "[RS_ASIO] Copy to Rocksmith"
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

    echo "Add the following launch option to Rocksmith on steam"
    echo 
    echo "================================================================"
    echo $LAUNCH_OPTIONS
    echo "================================================================"
}

cleanup() {
    print_blue "======== CLEANUP ========"
    #rm -rf $WINEPREFIX
}

################### Execute ################### 
greet
print_system_info
backup
prepare
patch_wineasio
patch_rs_asio
add_configs
patch_cdlc
finalise
cleanup
