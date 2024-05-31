#!/usr/bin/env bash

set -e

######################### VARS ###############################
USER=$(whoami)
WINEASIODLLS=(
    "/i386-unix/wineasio32.dll.so" 
    "/i386-windows/wineasio32.dll" 
    "/x86_64-unix/wineasio64.dll.so" 
    "/x86_64-windows/wineasio64.dll"
)

PROTONVER="Proton - Experimental"
WINEASIOPATH="${LD_WINEASIO_PATH}/lib/wine" 
WINEPREFIX="/home/${USER}/.wine"

STEAMPATH="/home/${USER}/.steam/steam"
PROTONPATH="${STEAMPATH}/steamapps/common/${PROTONVER}"
WINE="${PROTONPATH}/files/bin/wine"
WINE64="${PROTONPATH}/files/bin/wine64"

LAUNCH_OPTIONS="LD_PRELOAD=\$LD_PIPEWIRE_JACK_PATH/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%"
#############################################################

greet() {
    echo "======== Rocksmith 2014 - Wineasio patcher for NixOS ========"
    echo hello $USER!
    echo "Before starting, add the cdlcs dlls (D3DX9_42.dll & xinput1_3.dll) in the cdlc directory"
    read -p "Do you want to continue? (Y/N): " user_input
    user_input=$(echo "$user_input" | tr '[:lower:]' '[:upper:]')
    if [ "$user_input" != "Y" ]; then
        echo "Exiting..."
        exit 0
    fi
}

backup() {
    echo "Bacukp..."
    ## TODO: make backup before doing stuff
}

print_system_info() {
    echo "======== System Info "========
    echo "NixOS $(nixos-version)"
    echo "Wine $(steam-run "${WINE}" --version)"
    echo "Wine64 $(steam-run "${WINE64}" --version)"
}

prepare() {
    echo "======== Check and prepare "========

    ## Create .wine dir
    rm -rf $WINEPREFIX
    mkdir $WINEPREFIX

    CHECKPATHS=(
        "$WINEPREFIX"
        "$WINEASIOPATH"
        "$STEAMPATH"
        "$PROTONPATH"
        "$LD_PIPEWIRE_JACK_PATH"
        "$LD_WINEASIO_PATH"
        "${STEAMPATH}/steamapps/compatdata/221680" 
        "${STEAMPATH}/steamapps/compatdata/221680/pfx/"
    )

    CHECKFILES=(
        "$WINE"
        "$WINE64"
    )

    for path in "${CHECKPATHS[@]}"; do
        if [ ! -d "${path}" ]; then
            echo "Necessary directory ${path} not found!"
            exit 1
        fi
    done

    for file in "${CHECKFILES[@]}"; do
        if [ ! -f "${file}" ]; then
            echo "Necessary file ${file} not found!"
            exit 1
        fi
    done


    # TODO: Check steam-run installed
    ## TODO: Find a way to specify an actual prefix!
    echo "Copying ${STEAMPATH}/steamapps/compatdata/221680/pfx/* --> ${WINEPREFIX}/"
    cp -a -r "${STEAMPATH}/steamapps/compatdata/221680/pfx/"* "${WINEPREFIX}/"
}

register_dll() {
    echo "[Wineasio] Registering ${1}"
    steam-run "${2}" regsvr32 "${1}" > /dev/null 2>&1
}

safe_copy() {
    echo "[COPY FILE] $1 -> $2"
    rm -rf "$2"
    cp "$1" "$2"
}

patch_wineasio_32bit() {
    echo "[Wineasio] Applying Patch for 32-bit"
    safe_copy "${WINEASIOPATH}${1}" "${PROTONPATH}/files/lib/wine${1}"

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
    echo "======== Wineasio ========"
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

    ### Copy patched wineprefix back
    rm -rf ${STEAMPATH}/steamapps/compatdata/221680/pfx
    mkdir ${STEAMPATH}/steamapps/compatdata/221680/pfx
    cp -a -r "${WINEPREFIX}/"* "${STEAMPATH}/steamapps/compatdata/221680/pfx/"
}

patch_rs_asio() {
    echo "======== RS_ASIO ========"

    echo "[RS_ASIO] Dowload RS_ASIO"
    if [ ! -f "release-0.7.1.zip" ]; then
        wget https://github.com/mdias/rs_asio/releases/download/v0.7.1/release-0.7.1.zip > /dev/null 2>&1
    fi

    echo "[RS_ASIO] Unzip"
    unzip release-0.7.1.zip -d RS_ASIO

    echo "[RS_ASIO] Copy to Rocksmith"
    cp -a "RS_ASIO/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}

add_configs() {
    echo "======== CONFIGURATION ========"
    echo "[CONF] Copy configs"
    cp -a "config/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}

patch_cdlc() {
    echo "======== CDLCs ========"
    echo "[CDLC] Install CDLC Patch"
    cp -a "cdlc/"* "${STEAMPATH}/steamapps/common/Rocksmith2014/"
}


finalise() {
    echo "======== DONE ========"

    echo "Patch applied, you can now configure Rocksmith"

    echo "Add the following launchg option to Rocksmith on steam"
    echo "========================================================="
    echo $LAUNCH_OPTIONS
    echo "========================================================="
}

cleanup() {
    echo "======== CLEANUP ========"
    rm -rf $WINEPREFIX
}

################### Execute ################### 

greet
backup
prepare
print_system_info
patch_wineasio
patch_rs_asio
add_configs
patch_cdlc
finalise
cleanup
