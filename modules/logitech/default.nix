{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.logitech;
in
{
  options.modules.nixos.logitech = {
    enable = mkEnableOption "Enable utils for Logitech Devices";
  };

  config = mkIf cfg.enable {
    services.solaar.enable = true;
    environment.systemPackages = with pkgs; [
      usbutils
      logitech-udev-rules
    ];
  };
}
