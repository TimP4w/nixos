{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.plymouth;
in
{
  options.modules.nixos.plymouth = {
    enable = mkEnableOption "Enable plymouth";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [ 
        "splash" 
        "boot.shell_on_fail"  
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      initrd.systemd.enable = true;
      plymouth = {
        enable = true;
        theme = "hexagon_dots_alt";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["hexagon_dots_alt"];
          })
        ];
      };
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
