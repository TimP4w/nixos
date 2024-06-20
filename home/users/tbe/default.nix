{ inputs, lib, config, pkgs, pkgs-unstable, VARS, ... }:
{
  imports = [
    ../../modules/common
    ../../modules/git
    ../../modules/nvim
    ../../modules/zsh
  ];

  home = {
    username = VARS.userSettings.username;
    homeDirectory = "/home/${VARS.userSettings.username}";
  };

  home.packages = with pkgs; [
    oh-my-posh
  ] ++ (with pkgs-unstable; [ ]);

  programs.git = {
    userName = VARS.userSettings.name;
    userEmail = VARS.userSettings.email;

    includes = [
      {
        condition = "gitdir/i:timp4w/";
        contents = {
          user = {
            name = "TimP4w";
            email = "beskent@gmail.com";
          };
        };
      }
    ];

    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.stateVersion = "23.11";
}
