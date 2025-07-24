{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.grub;
in
{
  options.modules.nixos.grub = {
    enable = mkEnableOption "Enable Grub";
    resolution = mkOption {
      type = types.str;
      description = "Supported screen resolution for gfxmodeEfi";
    };
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
          gfxmodeEfi =  cfg.resolution; # "5120x1440";
        };
      };
    };

    time.hardwareClockInLocalTime = false; # Fix for windows time (set to true, but maybe causing problems)
  };
}
