{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.grub;
in
{
  options.modules.nixos.grub = {
    enable = mkEnableOption "Enable Grub";
  };

  config = mkIf cfg.enable {
    # Bootloader.
    # boot.loader.systemd-boot.enable = true;
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };

    time.hardwareClockInLocalTime = true; # Fix for windows time
  };
}
