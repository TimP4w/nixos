{ inputs, lib, config, pkgs, pkgs-unstable, VARS, ... }:
{
  imports = [
    ./modules/common

    ./modules/browsers/brave.nix

    ./modules/development
    ./modules/development/kubernetes.nix
    ./modules/development/terraform.nix

    ./modules/gaming

    ./modules/git

    ./modules/hyprland
    ./modules/gnome

    ./modules/kitty

    ./modules/nvim

    ./modules/ssh

    ./modules/zsh

    ./modules/rclone
  ];

  accounts.email.accounts = {
    timMain = {
      primary = true;
      address = VARS.userSettings.email;
      thunderbird.enable = true;
      realName = VARS.userSettings.name;
    };
  };

  home = {
    username = VARS.userSettings.username;
    homeDirectory = "/home/${VARS.userSettings.username}";
  };

  home.packages = with pkgs; [
    plex-media-player
    spotify
    telegram-desktop
    discord
    go-task
    guitarix
    oh-my-posh
  ] ++ (with pkgs-unstable; [ ]);

  home.sessionPath = [
    "/home/timp4w/.nix/scripts"
    "$HOME/.local/bin"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
