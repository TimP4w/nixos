{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.network;
in
{
  options.modules.nixos.network = {
    enable = mkEnableOption "Enable Network";
  };

  config = mkIf cfg.enable {
    ## Network
    networking.hostName = VARS.hostSettings.hostname;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    security.pki.certificateFiles = [
      ./certs/nas.crt
      ./certs/proxmox.crt
    ];

    # Disable warp calling home and prevent showing update banner (https://github.com/warpdotdev/Warp/issues/1991)
    #networking.extraHosts =
    #  ''
    #    127.0.0.1 releases.warp.dev
    #    127.0.0.1 app.warp.dev
    #  '';
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}
