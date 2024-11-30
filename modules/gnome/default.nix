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
      # xkb.variant = "de";

      displayManager = {
        gdm.enable = true;
      };

      desktopManager = {
        gnome.enable = true;
      };
      
      # videoDrivers = ["nvidia"];
    };

    # Causes login to crash. Then it's impossible to use custom ENVs.
    # services.displayManager.autoLogin.user = "timp4w"; # TODO: get from VARS


    services.libinput.enable = true;

    programs = {
      dconf.enable = true;
      # nautilus-open-any-terminal = {
      #   enable = true;
      #   terminal = "warp-terminal";
      # };
    };

    environment = {
      variables = {
        GTK_THEME = "WhiteSur-Dark";
        MUTTER_DEBUG_KMS_THREAD_TYPE="user"; # https://bbs.archlinux.org/viewtopic.php?pid=2126478 Fixes immediate logout on GDM after login
        MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # https://gitlab.gnome.org/GNOME/mutter/-/issues/3352 Mouse stuttering in browser with VRR active (gnome)
        # MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
      };

      pathsToLink = [
        "/share/nautilus-python/extensions"
      ];

      systemPackages = with pkgs; [
        gnome-tweaks
        nautilus-python
        turtle
        cartridges 
        junction # select app to open file
        video-trimmer
        collision
        deja-dup
        gnome-decoder
        impression
        imagemagick
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
