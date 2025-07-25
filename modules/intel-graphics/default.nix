{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.intel-graphics;
in
{
  options.modules.nixos.intel-graphics = {
    enable = mkEnableOption "Enable Intel Graphics driverss";
  };

  config = mkIf cfg.enable {
    # Intel video drivers
    services.xserver.videoDrivers = [ "modesetting" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.intel-media-driver
      ];
      #extraPackages = with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
