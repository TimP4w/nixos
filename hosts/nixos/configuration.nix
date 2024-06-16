{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.home-manager
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" ]; # "splash" is breaking stuf...
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
  ];

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

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs pkgs-unstable VARS;
      vars = {
        hostName = config.networking.hostName;
      };
    };
    users.${VARS.userSettings.username} = import ../../home/${VARS.userSettings.username}.nix;
  };


  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
