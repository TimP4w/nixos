{ config, lib, pkgs, VARS, ... }:

{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Helper scripts
  home.file = {
    ".local/bin/rebuild" = {
      text = ''
        sudo nixos-rebuild switch --flake "/home/${VARS.userSettings.username}/.nix?submodules=1#${VARS.hostSettings.hostname}"
      '';
      executable = true;
    };
    ".local/bin/cleanup" = {
      text = ''
        sudo nix-collect-garbage -d
        sudo nix-store --gc
        sudo nix store verify --all
        sudo nix store repair --all
      '';
      executable = true;
    };
    ".local/bin/update" = {
      text = ''
        nix flake update /home/${VARS.userSettings.username}/.nix
        sudo nixos-rebuild switch --flake "/home/${VARS.userSettings.username}/.nix?submodules=1#${VARS.hostSettings.hostname}" --upgrade

      '';
      executable = true;
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # = {
  #  source = ./config;
  #  recursive = true; # Ensure the whole directory and its contents are copied
  #};

  # Nicely reload system units when changing configs
  systemd.user = {
    startServices = "sd-switch";
  };
}
