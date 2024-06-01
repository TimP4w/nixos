{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.grub;
  sleek-grub-theme-dark = pkgs.sleek-grub-theme.override {
    withStyle = "dark";
  };

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
          theme = sleek-grub-theme-dark;
          gfxmodeEfi = "2560x1440";
        };
      };
    };

    time.hardwareClockInLocalTime = true; # Fix for windows time
  };
}
