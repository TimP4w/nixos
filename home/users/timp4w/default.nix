{ config, pkgs, pkgs-unstable, lib, inputs, outputs, VARS, ... }:
{
  imports = [
    ../../modules/common

    ../../modules/browsers/brave.nix

    ../../modules/development
    ../../modules/development/kubernetes.nix
    ../../modules/development/terraform.nix
    ../../modules/development/go.nix

    ../../modules/gaming

    ../../modules/hyprland

    ../../modules/gnome

    ../../modules/kitty

    ../../modules/nvim

    ../../modules/ssh

    ../../modules/zsh

    ../../modules/git

    ../../modules/rclone
  ];

  accounts.email.accounts = {
    timMain = {
      primary = true;
      address = VARS.userSettings.email;
      thunderbird.enable = true;
      realName = VARS.userSettings.name;
    };
  };

  programs.git = {
    userName = VARS.userSettings.name;
    userEmail = VARS.userSettings.email;

    extraConfig = {
      pull = {
        rebase = true;
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpni+ggWelhFEBViG9U2eqT0/N5G8zyzTrXYwuqupd1";
      };

      gpg = {
        program = "gpg";
        format = "ssh";
        ssh = {
          program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        };
      };
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
    slack
    postman
    synology-drive-client
    beekeeper-studio
    obsidian
  ] ++ (with pkgs-unstable; [
    zed-editor
  ]);


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
