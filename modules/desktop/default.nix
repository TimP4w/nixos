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
      nh # https://github.com/viperML/nh
      nixd # TODO: Move to dev module 
      nixpkgs-fmt
      onlyoffice-bin_latest
      
      papers # PDF Reader      
      resources # Resource monitor
      turtle # Git GUI
      cartridges # Game launcher
      junction # select app to open file
      video-trimmer
      collision # Calculate software hash
      deja-dup # Backup
      gnome-decoder # QR Codes
      impression # Bootable USB writer
      clapper # Video player
      amberol # Audio player
    ];
  };
}
