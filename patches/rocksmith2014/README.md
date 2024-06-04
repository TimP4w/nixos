# Rocksmith 2014

Code in this directory is licensed with LGPL-2.1 license due to the copied parts of the wineasio-register script.

## NixOS
Minimal config needed

```
  ### Audio
  sound.enable = true;

  services.pipewire = {
    enable = true;
    jack.enable = true; 
  };


  ### Audio Extra 
  security.rtkit.enable = true; # Enables rtkit (https://directory.fsf.org/wiki/RealtimeKit)
  
  #
  # domain = "@audio": This specifies that the limits apply to users in the @audio group.
  # item = "memlock": Controls the amount of memory that can be locked into RAM.
  # value (`unlimited`) allows members of the @audio group to lock as much memory as needed. This is crucial for audio processing to avoid swapping and ensure low latency.
  #
  # item = "rtprio": Controls the real-time priority that can be assigned to processes.
  # value (`99`) is the highest real-time priority level. This setting allows audio applications to run with real-time scheduling, reducing latency and ensuring smoother performance.
  #
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  # Add user to `audio` and `rtkit` groups.
  users.users.<username>.extraGroups = [ "audio" "rtkit" ];

  environment.systemPackages = with pkgs; [
    qjackctl
    rtaudio 
  ];

  ### Steam (https://nixos.wiki/wiki/Steam)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraLibraries = pkgs: [ pkgs.pkgsi686Linux.pipewire.jack ]; # Adds pipewire jack (32-bit)
      extraPkgs = pkgs: [ pkgs.wineasio ]; # Adds wineasio
    };
  };

```

## How-to

### 1. Add the NixOS config and rebuild the system
You need to reboot afterwards

### 2. Open Steam
Activate proton, `Settings` > `Compatibility` > `Enable Steam play for all other titles` and restart steam.


### 3. Download Rocksmith 2014 and launch it once
Simply download Rocksmith 2014 and launch it one time

### 4. Patch
Prerequisites:
- Ensure you launched Rocksmith at least once
- Copy the CDLC patch `*.dll` inside the `cdlc` directory
- `steam-run` installed (i.e. steam is in a fhs env)

Run `steam-run ./patch.sh`

### 5. Add Launch Options to Rocksmith
Copy the following command and paste it as Launch Options (Steam > Rocksmith 2014 > Right Click > Properties... > General > Launch Options)

``` 
LD_PRELOAD=/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%
```

### 6. Test & Enjoy
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
- [ ] Latency is not perfect. Enabling other RT options may increase performance slightly. However it's playable and comparable to Windows'.
- [ ] Proton updates may require a re-patching (however system updates should work fine).
- [ ] We (mostly) can't change the inputs of Rocksmith when it's running, otherwise it will crash. Therefore disabling the devices we don't want to automatically connect is often required.
