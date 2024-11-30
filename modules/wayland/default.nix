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
        enable = true;

        displayManager = {
          gdm.wayland = true;
        };
      };
      
      environment = {
        variables = {
          QT_QPA_PLATFORM = "wayland";
          NIXOS_OZONE_WL = 1; # Workaround for electron apps
          # WLR_NO_HARDWARE_CURSORS = 1;
        };

        systemPackages = with pkgs; [
          wl-clipboard
          # xwaylandvideobridge
        ];
      };
  };
}
