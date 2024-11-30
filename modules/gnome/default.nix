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
      xkb.variant = "de";

      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
      };

      desktopManager = {
        gnome.enable = true;
      };
      
      # videoDrivers = ["nvidia"];
    };

    # Causes login to crash. Then it's impossible to use custom ENVs.
     services.displayManager.autoLogin.user = "timp4w"; # TODO: get from VARS


    services.libinput.enable = true;

    programs = {
      dconf.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty"; # TODO: change to warp?
      };
    };

    environment = {
      variables = {
        QT_QPA_PLATFORM = "wayland";
        GTK_THEME = "WhiteSur-Dark";
        MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # https://gitlab.gnome.org/GNOME/mutter/-/issues/3352 Mouse stuttering in browser with VRR active (gnome)
        # MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
      };

      pathsToLink = [
        "/share/nautilus-python/extensions"
      ];

      systemPackages = with pkgs; [
        gnome-tweaks
        wl-clipboard
        nautilus-python
        turtle
        evolution-ews # Evolution Connector for Exchange Web Services (i.e. contacts, email, calendar)
      ];

      gnome.excludePackages = with pkgs; [
          gnome-photos
          gnome-tour
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
      ];
    };

    #Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
