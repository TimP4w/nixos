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
      NIXOS_OZONE_WL = 1; # Workaround for electron apps
      # WLR_NO_HARDWARE_CURSORS = 1;
      # QT_QPA_PLATFORM = "wayland";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    # Enable HW accelerated graphics driver
    hardware.graphics = {
      enable = true;
      #enable32Bit = true;
    
      extraPackages = [
        pkgs.intel-media-driver
      ];
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
      
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "565.57.01";
      #  sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      #  sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
      #  openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      #  settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
      #  persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
      #};

      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
