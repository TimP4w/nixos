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
      forceFullCompositionPipeline = false; # Issues during boot
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "575.51.02";
      #  sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      #  sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
      #  openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      #  settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      #  persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
      #  usePersistenced = false;
      #};

    };
  };
}
