{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_15;
    kernelParams = [ "quiet" ];
    # blacklistedKernelModules = [  ];
    #initrd.kernelModules = [ ];
  };

  environment.systemPackages = with pkgs; [
    python3
    nodejs
    gparted
    vscode
    gnupg
    pinentry
    pinentry-tty
    xclip
    binutils
  ] ++ (with pkgs-unstable; [
    warp-terminal
  ]);

  # Fingerprint Sensor
  services.fprintd = {
    enable = true;
  };
  #security.pam.services.login.fprintAuth = true;
  security.pam.services.gdm.fprintAuth = true;

  # Intel video drivers
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.intel-media-driver
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

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
      enable = false;
      enableRocksmith2014 = false; # Needs reboot if toggled
    };
    gnome.enable = true;
    plasma.enable = false;
    # hyprland.enable = false;
    grub = {
      enable = true;
      resolution = "2880x1800";
    };
    ld.enable = true;
    network.enable = true;
    nvidia.enable = false;
    zsh.enable = true;
    password-manager.enable = true;
    logitech.enable = true;
    bluetooth.enable = true;
    wayland.enable = true;
    plymouth.enable = true;
  };

  #   services.xserver.xkb = {
  #  layout = "ch";
   # variant = "de_nodeadkeys";
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.${VARS.userSettings.username} = {};

  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" "dialout" "video" VARS.userSettings.username ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
