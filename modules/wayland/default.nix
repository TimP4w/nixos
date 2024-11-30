{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.wayland;
in
{
  options.modules.nixos.wayland = {
    enable = mkEnableOption "Enable Wayland";
  };

  config = mkIf cfg.enable {
      services.xserver = {
        # enable = false;

        displayManager = {
          gdm.wayland = false;
        };
      };
      
      environment = {
        variables = {
          QT_QPA_PLATFORM = "wayland";
          NIXOS_OZONE_WL = 1; # Workaround for electron apps
          # WLR_NO_HARDWARE_CURSORS = 1;
          
          # Gnome stuff (TODO: only activate if gnome settings is enabled)
          MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # https://gitlab.gnome.org/GNOME/mutter/-/issues/3352 Mouse stuttering in browser with VRR active (gnome)
          # MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
          # MUTTER_DEBUG_KMS_THREAD_TYPE=user; # https://bbs.archlinux.org/viewtopic.php?pid=2126478
        };

        systemPackages = with pkgs; [
          wl-clipboard
          # xwaylandvideobridge
          ];
      };
  };
}
