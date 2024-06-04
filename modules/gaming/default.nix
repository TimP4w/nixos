{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.gaming;
in
{
  options.modules.nixos.gaming = {
    enable = mkEnableOption "Enable Gaming Config";
    enableRocksmith2014 = mkEnableOption "Enable audio configuration needed for Rocksmith 2014";
  };

  config = mkIf cfg.enable
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        package = pkgs.steam.override {
          extraLibraries = pkgs: [ pkgs.pkgsi686Linux.pipewire.jack ]; # Needed by Rocksmith2014
          extraPkgs = pkgs: [ pkgs.wineasio ]; # Needed by Rocksmith2014
        };
      };

      modules.nixos.audio = mkIf cfg.enableRocksmith2014 {
        enable = true;
        enableRealTime = true;
      };

    };
}
