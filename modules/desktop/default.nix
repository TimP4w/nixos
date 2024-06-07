{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.desktop;
in
{
  options.modules.nixos.desktop = {
    enable = mkEnableOption "Enable Desktop Config";
  };

  config = mkIf cfg.enable {
    # Printing
    services.printing.enable = true;

    # Fonts
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      corefonts # windows fonts, Segoe UI missing ):
    ];

    # Basic desktop packages
    programs.firefox.enable = true;
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [
      brave
      thunderbird # HW Acceleration makes it crash ):
      resources
      papers # PDF Reader
      nh # https://github.com/viperML/nh
      nixd # TODO: Move to dev module 
      nixpkgs-fmt
      onlyoffice-bin_latest
      (mpv.override {
        scripts = [
          mpvScripts.modernx
          mpvScripts.reload
          mpvScripts.thumbfast
          mpvScripts.mpris
        ];
      })
      amberol
    ];
  };
}
