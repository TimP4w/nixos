{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ../modules/gnome.nix
      ../modules/audio.nix
      ../modules/nvidia.nix
      ../modules/fonts.nix
      ../modules/network.nix
      ../modules/locale.nix
      ../modules/shell.nix
      ../modules/packages.nix
      ../modules/services.nix
      ../modules/docker.nix
      ../modules/grub.nix

      inputs.home-manager.nixosModules.home-manager
    ];

  # TODO
  # boot = {
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   kernelParams = [ "quiet" ];
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
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

  environment.variables = {
    NIXOS_CONFIG_DIR = VARS.hostSettings.configDir;
  };


  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";

}
