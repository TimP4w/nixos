{ pkgs, VARS, ... }:

{
  home.packages = with pkgs; [
    thefuck
  ];

  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      theme = "gnzh"; #"af-magic";
      plugins = [
        "sudo"
        "terraform"
        "systemadmin"
        "vi-mode"
        "git"
        "thefuck"
        # "autoenv"
        "direnv"
        "fluxcd"
      ];
    };

    shellAliases = {
      ll = "ls -l";
      nix-rebuild = "cd $NIXOS_CONFIG_DIR && sudo nixos-rebuild switch --flake .#${VARS.hostSettings.hostname}";
      nix-cleanup = "cd $NIXOS_CONFIG_DIR && sudo scripts/cleanup.sh";
      nix-run = "nix-shell --run $SHELL -p";
    };

    initExtra = ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      eval "$(oh-my-posh init zsh)"
    '';

    history = {
      size = 10000;
    };
  };
}
