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
      };

      modules.nixos.audio = mkIf cfg.enableRocksmith2014 {
        enable = true;
        enableRealTime = true;
      };

      environment.systemPackages = mkIf cfg.enableRocksmith2014 (with pkgs; [
        wineasio # Wineasio compiled
        pkgsi686Linux.pipewire.jack # 32-bit lib for pipewire jack
      ]);

      environment.variables = mkIf cfg.enableRocksmith2014 {
        LD_WINEASIO_PATH = "${pkgs.wineasio}";
        LD_PIPEWIRE_JACK_PATH = "${pkgs.pkgsi686Linux.pipewire.jack}";
      };
    };
}
