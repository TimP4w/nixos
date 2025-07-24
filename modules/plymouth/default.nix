{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.plymouth;
  gnomeCfg = config.modules.nixos.gnome;
in
{
  options.modules.nixos.plymouth = {
    enable = mkEnableOption "Enable plymouth";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [ 
        # "splash" this is already set elsewhere, don't repeat it 
        "boot.shell_on_fail"  
        #"loglevel=3"
        #"rd.systemd.show_status=false"
        #"rd.udev.log_level=3"
        #"udev.log_priority=3"
      ];
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
      initrd = {
        verbose = false;
        systemd.enable = true;
      };
    };

    services.displayManager = {
      autoLogin.user = VARS.userSettings.username;
      autoLogin.enable = true;
    };


    # TODO: Observe this 
    # Several issues with gdm: https://github.com/NixOS/nixpkgs/issues/309190
    # Also, without autologin but with plymouth, login fails the first time
    # Workaround is to disable systemd services getty@tty1 and autovt@tty1 (https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229)
    systemd.services."getty@tty1".enable = mkIf gnomeCfg.enable false;
    systemd.services."autovt@tty1".enable = mkIf gnomeCfg.enable false;
  };
}
