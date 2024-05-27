{ pkgs, VARS, ... }:
{
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

}
