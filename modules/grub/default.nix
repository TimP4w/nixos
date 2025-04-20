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
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
          theme = (pkgs.sleek-grub-theme.override { withStyle = "dark"; });
          gfxmodeEfi = "5120x1440";
        };
      };
    };

    time.hardwareClockInLocalTime = true; # Fix for windows time
  };
}
