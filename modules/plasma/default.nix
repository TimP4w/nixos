{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.plasma;
in
{
  options.modules.nixos.plasma = {
    enable = mkEnableOption "Enable Plasma";
  };

  config = mkIf cfg.enable {

    services = {
      xserver = {
        enable = true;

        # Configure keymap in X11
        xkb.layout = "ch";
        # xkb.variant = "de";

        desktopManager = {
          plasma6.enable = true;
        };

        displayManager = {
          sddm.enable = true;
          sddm.wayland.enable = true;
          sddm.settings.General.DisplayServer = "wayland";
        };
      };

      /* Next version will be like this
      desktopManager = {
        gnome.enable = true;
      };

      displayManager = {
        gdm.enable = true;
      };*/

      libinput.enable = true;
    };
       


    programs = {
      dconf.enable = true;
      # nautilus-open-any-terminal = {
      #   enable = true;
      #   terminal = "warp-terminal";
      # };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    environment = {
      variables = {
        # MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # https://gitlab.gnome.org/GNOME/mutter/-/issues/3352 Mouse stuttering in browser with VRR active (gnome). This doesn't work anymore, and now disables HDR support...
        # MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
      };



      systemPackages = with pkgs; [

      ];

      plasma6.excludePackages = with pkgs; [
        # plasma-browser-integration
        kdePackages.elisa
      ];
    };

    #Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
