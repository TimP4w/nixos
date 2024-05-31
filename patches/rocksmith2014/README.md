# Rocksmith 2014

Code in this directory is licensed with LGPL-2.1 license due to the copied parts of the wineasio-register script.

## NixOS


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
