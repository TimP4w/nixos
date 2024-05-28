{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.zsh;
in
{
  options.modules.nixos.zsh = {
    enable = mkEnableOption "Enable ZSH";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.zsh.shellAliases = {
      ll = "ls -l";
      nix-rebuild = "cd $NIXOS_CONFIG_DIR && sudo nixos-rebuild switch --flake .#${VARS.hostSettings.hostname}";
      nix-cleanup = "cd $NIXOS_CONFIG_DIR && sudo scripts/cleanup.sh";
      nix-run = "nix-shell --run $SHELL -p";
    };

    users.defaultUserShell = pkgs.zsh;

    environment.shells = with pkgs; [ zsh ];

    users.users.${VARS.userSettings.username} = {
      shell = pkgs.zsh;
    };
  };
}
