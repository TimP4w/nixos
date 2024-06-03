{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.audio;
in
{
  options.modules.nixos.audio = {
    enable = mkEnableOption "Enable Audio";
    enableRealTime = mkEnableOption "Enable Realtime Audio Config";
  };
  config = mkIf cfg.enable
    {
      # Enable sound with pipewire.
      sound.enable = true;
      hardware.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack = mkIf cfg.enableRealTime {
          enable = true;
        };

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      environment.systemPackages = with pkgs; [
        pavucontrol
      ] ++ optionals cfg.enableRealTime [
        qjackctl
        qpwgraph
        helvum
        rtaudio
      ];

      security.rtkit = mkIf cfg.enableRealTime {
        enable = true;
      };

      musnix = mkIf cfg.enableRealTime {
        #  # https://github.com/musnix/musnix
        enable = true;
        #  kernel = {
        #    #realtime = true;
        #    #packages = pkgs.linuxPackages_6_9_rt;
        #  };
        #
      };

      users.users.${VARS.userSettings.username} = mkIf cfg.enableRealTime {
        extraGroups = [ "audio" "rtkit" ];
      };

    };
}
