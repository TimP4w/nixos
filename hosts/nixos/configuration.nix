{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "quiet" ]; # "splash" is breaking stuf...
    initrd.systemd.enable = false; # Breaks a lot of things (login crash, keyring not unlocking, etc.)
    plymouth.enable = false;
  };

  ## Backup Disks RAID
  #
  # `$ sudo mdadm --assemble --scan`
  # `$ sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf`
  #
  # fileSystems."/mnt/raid" = {
  #   device = "/dev/md0";
  #   fsType = "ext4";
  #   options = [ "defaults" ];
  # };
  # systemd.services.mdadm = {
  #   description = "MDADM RAID arrays";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "local-fs.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.mdadm}/bin/mdadm --assemble --scan";
  #     ExecStop = "${pkgs.mdadm}/bin/mdadm --stop --scan";
  #     RemainAfterExit = true;
  #   };
  # };

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
    #cnspec # security (mondoo)
    #cnquery
    # xwaylandvideobridge
  ];

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
    hyprland.enable = true;
    grub.enable = true;
    ld.enable = true;
    network.enable = true;
    nvidia.enable = true;
    zsh.enable = true;
    password-manager.enable = true;
    logitech.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="on"
  '';

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
