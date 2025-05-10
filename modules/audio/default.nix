{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.audio;
in
{
  options.modules.nixos.audio = {
    enable = mkEnableOption "Enable Audio With Pipewire";
    enableRealTime = mkEnableOption "Enable (some) Realtime Audio Config";
  };
  config = mkIf cfg.enable
    {
      services.pulseaudio = {
        enable = false;
        # support32Bit = true;
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

      };

      environment.systemPackages = with pkgs; [
        pavucontrol
      ] ++ optionals cfg.enableRealTime [
        qjackctl
        qpwgraph
        helvum
        rtaudio
      ];

      #### Realtime configs (https://github.com/musnix/musnix)
      security.rtkit = mkIf cfg.enableRealTime {
        enable = true; # Enables rtkit (https://directory.fsf.org/wiki/RealtimeKit)
      };

      security.pam.loginLimits =
        if cfg.enableRealTime then [
          { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
          { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
          #{ domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }  # This breaks ESync for Lutris ): This is why musnix is not used
          #{ domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
        ] else [ ];

      users.users.${VARS.userSettings.username} = mkIf cfg.enableRealTime {
        extraGroups = [ "audio" "rtkit" ];
      };

      # Rocksmith doesn't need these
      # boot = mkIf cfg.enableRealTime {
      #   kernel.sysctl = { "vm.swappiness" = 10; };
      #   kernelParams = [ "threadirqs" ];
      # };
      #
      # powerManagement = mkIf cfg.enableRealTime {
      #   cpuFreqGovernor = "performance";
      # };
      # services.udev = {
      #   extraRules = ''
      #     KERNEL=="rtc0", GROUP="audio"
      #     KERNEL=="hpet", GROUP="audio"
      #     DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      #   '';
      # };
      #
      # Adds the things above, however we don't want them all
      #
      # musnix = mkIf cfg.enableRealTime {
      #  # https://github.com/musnix/musnix
      #  enable = true;
      #  kernel = {
      #    #realtime = true;
      #    #packages = pkgs.linuxPackages_6_9_rt;
      #  };
      #
      #};
    };
}
