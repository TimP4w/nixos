{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.home-manager
    ];

  # TODO
  # boot = {
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   kernelParams = [ "quiet" ];
  # };

  environment.systemPackages = with pkgs; [
    python3
    nodejs
    python3
    nodejs
    gparted
    vscode
    warp-terminal
    nixpkgs-fmt
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
