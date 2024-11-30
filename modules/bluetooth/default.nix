{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.bluetooth;
in
{
  options.modules.nixos.bluetooth = {
    enable = mkEnableOption "Enable Blueooth";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
    services.blueman.enable = true;
  };
}
