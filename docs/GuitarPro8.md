# Guitar Pro 8

## Install

Ensure wine and winetricks are installed

```nix
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable  # 32-bit and 64-bit Wine
    winetricks              # Wine helper script
  ];
}

```

Create a 64-bit wine prefix

```bash
mkdir ~/wine-apps/guitar-pro-8
export WINEPREFIX=~/wine-apps/guitar-pro-8
export WINEARCH=win64
winecfg
```

Install required libraries

```bash
winetricks vcrun2019 dxvk corefonts

```

Install Guitar Pro

```bash
wine ~/Downloads/guitar-pro-8-setup.exe

```

## Fonts Fix

In `~/wine-apps/guitar-pro-8/drive_c/Program Files/Arobas Music/Guitar Pro 8` edit the file `qt.conf` and add

```
[Platforms]
WindowsArguments = fontengine=freetype
```
