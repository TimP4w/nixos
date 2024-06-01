# Rocksmith 2014

Code in this directory is licensed with LGPL-2.1 license due to the copied parts of the wineasio-register script.

## NixOS
Minimal config needed (audio)

```
  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    jack.enable = true; 
  };

  musnix.enable = true; # Check https://github.com/musnix/musnix for how to install

  environment.systemPackages = with pkgs; [
    qjackctl
    rtaudio 
    wineasio  # Wineasio compiled
    pkgsi686Linux.pipewire.jack # 32-bit lib for pipewire jack
  ];

  # Export env variables with store location (if these change, we need to re-patch!)
  environment.variables = {
    LD_WINEASIO_PATH = "${pkgs.wineasio}";
    LD_PIPEWIRE_JACK_PATH = "${pkgs.pkgsi686Linux.pipewire.jack}";
  };

  users.users.<username>.extraGroups = [ "audio" "rtkit" ];

  programs.steam.enable = true; 

```

## How-to

### 1. Install Steam and login
```
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.systemPackages = with pkgs; [
    wineasio
    pkgsi686Linux.libjack2
  ];
```

Activate proton, `Settings` > `Compatibility` > `Enable Steam play for all other titles` and restart steam.


### 2. Download Rocksmith 2014 and launch it once
Simply download Rocksmith 2014 and launch it one time

### 3. Patch
Prerequisites:
- Ensure you launched Rocksmith at least once
- Copy the CDLC patch `*.dll` inside the `cdlc` directory


Run `./patch.sh` 

### 4. Add Launch Options to Rocksmith
Copy the following command and paste it as Launch Options (Steam > Rocksmith 2014 > Right Click > Properties... > General > Launch Options)

``` 
LD_PRELOAD=$LD_PIPEWIRE_JACK_PATH/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%
```

### 5. Test & Enjoy
- Open `qjackctl` to see if Rocksmith is showing up
- You may need to disable some devices if Rocksmith connects to the wrong ones 

## Tested & Working with
```
======== System Info ========
NixOS 24.05.20240524.d12251e (Uakari) [64-bit]
Wine wine-9.0
Wine64 wine-9.0
Wineasio wineasio-1.2.0
Pipewire Jack pipewire-1.0.6-jack
RS_ASIO (Desired) 0.7.1
Proton (Desired) Proton - Experimental
```
- Device: Focusrite Scarlett Solo (3rd Gen.)


## Known Problems / Issues & TODOs
- [ ] Latency is not ideal. Pretty low but noticeable when there are many fast notes. Rocksmith still picks them up but the audio delay is at the limit of tolerable.
- [ ] Proton updates may require a re-patching (however system updates should work fine).
- [ ] This is breaking a bit the "nix way", since we need to know the store location of pipewire-jack 32-bit library.
- [ ] VBASIOTest32.exe doesn't work, because the 32-bit library of JACK is not linked to pipewire. For Rocksmith it works because we explicitely add it (see point #4.). A patch of the pipewire service was attempted and worked, but it's not desirable to maintain it separately only for this. Maybe a PR on nixpkgs should be considered?
- [ ] We can't change the inputs of Rocksmith when it's running, otherwise it will crash. Therefore disabling the devices we don't want to automatically connect is required.
- [ ] Needs musnix but I'm not exactly sure why. Need to test.
- [ ] We need to copy the content of the `pfx` dir into `~/.wine` because we can't use prefixes with `steam-run` (or actually I don't know how to do it). Needs some research.
- [ ] Backup directories before making changes.
