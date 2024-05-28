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
    ];

    # Basic desktop packages
    programs.firefox.enable = true;
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}
