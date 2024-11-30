{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ 
      "quiet" 
      "splash" 
      "boot.shell_on_fail"  
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = "hexagon_dots_alt";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon_dots_alt"];
        })
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
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
    #cnspec # security (mondoo)
    #cnquery
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
    hyprland.enable = false;
    grub.enable = true;
    ld.enable = true;
    network.enable = true;
    nvidia.enable = true;
    zsh.enable = true;
    password-manager.enable = true;
    logitech.enable = true;
    bluetooth.enable = true;
    wayland.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # TODO Failed to write ATTR{/sys/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.3/power/control}="on", ignoring: No such file or directory
  #services.udev.extraRules = ''
  #  ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="on"
  #'';

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
