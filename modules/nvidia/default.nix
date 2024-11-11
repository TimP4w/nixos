{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.nvidia;
in
{
  options.modules.nixos.nvidia = {
    enable = mkEnableOption "Enable Nvidia";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    environment.systemPackages = with pkgs; [
      nvitop
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Workaround for electron apps
      # WLR_NO_HARDWARE_CURSORS = 1;
      # QT_QPA_PLATFORM = "wayland";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # Mouse stuttering in browser with VRR active (gnome)
      # MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true; # Experimental: Enable this if you have graphical corruption issues or application crashes after waking up from sleep.
      powerManagement.finegrained = false; # Experimental. Fine-grained power management. Turns off GPU when not in use.
      open = false; # alpha open source kernel module (https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus )
      nvidiaSettings = true;
      # forceFullCompositionPipeline = true;

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.58.02";
        sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
        openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
        settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
      };
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "560.35.03";
      #   sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      #   sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
      #   openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
      #   settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
      #   persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
      # };
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
