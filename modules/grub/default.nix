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
          gfxmodeEfi = "1920x1200"; # "2560x1440"; Setting the correct resolution (even if supported by grub with `videoinfo` causes both grub and plymouth to be extremely laggy)
        };
      };
    };

    time.hardwareClockInLocalTime = true; # Fix for windows time
  };
}
