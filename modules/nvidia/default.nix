{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.nvidia;
in
{
  options.modules.nixos.nvidia = {
    enable = mkEnableOption "Enable Nvidia";
  };

  config = mkIf cfg.enable {

    # "still experimental" interface enables saving all video memory (given enough space on disk or RAM).
    # nvidia-suspend, nvidia-hibernate, nvidia-resume systemd services must be enabled
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia.NVreg_TemporaryFilePath=/var/tmp" "nvidia-modeset.hdmi_deepcolor=1" ];

    environment.systemPackages = with pkgs; [
      nvitop
    ];

    environment.sessionVariables = {
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    # Enable HW accelerated graphics driver
    hardware.graphics = {
      enable = true;
      #extraPackages = with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ];
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true; # Experimental: Enable this if you have graphical corruption issues or application crashes after waking up from sleep.
      powerManagement.finegrained = false; # Experimental. Fine-grained power management. Turns off GPU when not in use.
      open = true; # alpha open source kernel module (https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus )
      nvidiaSettings = true;
      forceFullCompositionPipeline = true; # Issues during boot
      # package = config.boot.kernelPackages.nvidiaPackages.beta;

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "565.77";
        sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
        sha256_aarch64 = "sha256-LSAYUnhfnK3rcuPe1dixOwAujSof19kNOfdRHE7bToE=";
        openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
        settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
        persistencedSha256 = "sha256-wnDjC099D8d9NJSp9D0CbsL+vfHXyJFYYgU3CwcqKww=";
      };

    };
  };
}
