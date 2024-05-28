{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.docker;
in
{
  options.modules.nixos.docker = {
    enable = mkEnableOption "Enable Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    users.users.${VARS.userSettings.username}.extraGroups = [ "docker" ];
  };
}
