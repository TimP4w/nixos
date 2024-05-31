{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.audio;
in
{
  disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];

  options.modules.nixos.audio = {
    enable = mkEnableOption "Enable Audio";
  };
  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    musnix.enable = true;
    # boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];

    nixpkgs.config.allowUnsuppoirtedSystem = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      qjackctl
      rtaudio
      wineasio
      qpwgraph
      pkgsi686Linux.pipewire
      pkgsi686Linux.libjack2
    ];

    users.users.${VARS.userSettings.username}.extraGroups = [ "audio" "rtkit" "realtime" ];

  };
}
