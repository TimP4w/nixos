{ config, pkgs, lib, inputs, outputs, pkgs-unstable, VARS, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  wsl.enable = true;
  wsl.defaultUser = VARS.userSettings.username;

  environment.systemPackages = with pkgs; [
    python3
    nodejs
    gnupg
    pinentry
    pinentry-tty
    jdk17
  ];

  modules.nixos = {
    basic.enable = true;
    docker.enable = true;
    ld.enable = true;
    network.enable = true;
    zsh.enable = true;
    password-manager.enable = true;
  };

  users.users.${VARS.userSettings.username} = {
    isNormalUser = true;
    description = VARS.userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "23.11";
}
