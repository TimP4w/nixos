{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.gnome;
in
{
  options.modules.nixos.gnome = {
    enable = mkEnableOption "Enable Gnome";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      # Configure keymap in X11
      xkb.layout = "ch";
      xkb.variant = "fr_nodeadkeys";

      displayManager = {
        gdm.enable = true;
      };

      desktopManager = {
        gnome.enable = true;
      };
    };

    services.libinput.enable = true;

    environment.variables = {
      QT_QPA_PLATFORM = "wayland";
      GTK_THEME = "WhiteSur-Dark";
    };

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      wl-clipboard
      gnome.nautilus-python
      turtle
    ];

    programs.dconf.enable = true;

    environment.gnome.excludePackages = (with pkgs;
      [
        gnome-photos
        gnome-tour
      ]) ++ (with pkgs.gnome;
      [
        cheese # webcam tool
        gnome-music
        epiphany # web browser
        # geary # email reader
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-initial-setup
        # gnome-contacts
        # gnome-characters
      ]);

    #Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

  };
}
