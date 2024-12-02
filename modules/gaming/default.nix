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
        # protontricks.enable = false;
        # package = pkgs.steam.override {
        #   extraLibraries = pkgs: [ 
        #     # pkgs.pkgsi686Linux.pipewire.jack 
        #   ]; # Needed by Rocksmith2014
        #   extraPkgs = pkgs: [ pkgs.wineasio ];
        # };
        extraPackages = [ pkgs.wineasio pkgs.pkgsi686Linux.pipewire.jack pkgs.pkgsi686Linux.libdrm ]; # Needed by Rocksmith2014
      };

      environment.sessionVariables = {
        JACK_32_BIT = [ "${pkgs.pkgsi686Linux.pipewire.jack}/lib" ];
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
        __GL_SHADER_DISK_CACHE = 1;
        __GL_SHADER_DISK_CACHE_SIZE = 100000000000;
      };


      modules.nixos.audio = mkIf cfg.enableRocksmith2014 {
        enable = true;
        enableRealTime = true;
      };
      
      # LD_PRELOAD=/nix/store/l591nwchhgrm8lnzqrxfjvp1zzdp4jyc-pipewire-1.2.6-jack/lib/libjack.so PIPEWIRE_LATENCY=256/48000 %command%
    };
}
