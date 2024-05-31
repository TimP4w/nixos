{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.gaming;
in
{
  options.modules.nixos.gaming = {
    enable = mkEnableOption "Enable Gaming Config";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };


    # /home/timp4w/.steam/steam/steamapps/common/Proton - Experimental/files
    # /home/timp4w/.steam/steam/steamapps/common/Rocksmith2014
    # /home/timp4w/.steam/steam/steamapps/compatdata/221680
    # find /home/timp4w/.steam/steam/steamapps/compatdata/221680/pfx -name wineasio.dll 

    environment.systemPackages = with pkgs; [
      protontricks
      wine
      wine64
      #wineWowPackages.stable
    ];
  };
}
