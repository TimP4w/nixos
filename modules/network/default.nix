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

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

    
    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # KDE Connect
      allowedUDPPortRanges = allowedTCPPortRanges; # KDE Connect
    };

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
