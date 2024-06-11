{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.logitech;
in
{
  options.modules.nixos.logitech = {
    enable = mkEnableOption "Enable utils for Logitech Devices";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      solaar # Logitech device control (not working?)
      usbutils
    ];
  };
}
