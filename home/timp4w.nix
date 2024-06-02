{ inputs, lib, config, pkgs, pkgs-unstable, VARS, ... }:
{
  imports = [
    ./common/base

    ./common/gui/gnome.nix

    ./common/apps/brave.nix
    ./common/apps/nvim
    ./common/apps/kitty.nix

    ./common/gaming

    ./common/dev/kubernetes.nix
    ./common/dev/terraform.nix

    ./configs/ssh

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
    _1password-gui
    _1password
    discord
    go-task
  ] ++ (with pkgs-unstable; [ ]);


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
