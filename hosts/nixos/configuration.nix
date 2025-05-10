{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_13;
    kernelParams = [ "quiet" ];
    blacklistedKernelModules = [ "amdgpu" ];
    #initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
  };

  environment.systemPackages = with pkgs; [
    python3
    nodejs
    python3
    nodejs
    gparted
    vscode
    warp-terminal
    mdadm # raid
    gnupg
    pinentry
    pinentry-tty
    xclip
    wineWowPackages.stable
    winetricks
    binutils
    #cnspec # security (mondoo)
    #cnquery
    # pkgs-unstable.liquidctl ## TODO Move to another "RGB" module
    #coolercontrol.coolercontrol-liqctld
    #coolercontrol.coolercontrold
    #coolercontrol.coolercontrol-gui
    openrgb
  ];

  # services.udev.packages = [ pkgs-unstable.liquidctl pkgs.openrgb ];

  virtualisation.waydroid.enable = true;

  modules.nixos = {
    basic.enable = true;
    docker.enable = true;
    audio = {
      enable = true;
      # enableRealTime = false;
    };
    desktop.enable = true;
    gaming = {
      enable = true;
      enableRocksmith2014 = true; # Needs reboot if toggled
    };
    gnome.enable = true;
    # hyprland.enable = false;
    grub.enable = true;
    ld.enable = true;
    network.enable = true;
    nvidia.enable = true;
    zsh.enable = true;
    password-manager.enable = true;
    logitech.enable = true;
    bluetooth.enable = true;
    wayland.enable = true;
    plymouth.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.${VARS.userSettings.username} = {};

  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" "dialout" VARS.userSettings.username ];
  };

      /*

    fileSystems."/mnt/k3s" = {
    device = "192.168.1.3:/volume1/k3s";
    fsType = "nfs";
    options = [ "nfsvers=4.1" ];
    };
  */


  # Hack to avoid a suspending loop after waking up. Mind that this system is NOT a laptop and doesn't have a lid...
  services.logind.lidSwitchExternalPower = "ignore";

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
