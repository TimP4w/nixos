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
      nix-rebuild = "$NIXOS_CONFIG_DIR/scripts/rebuild";
      nix-run = "nix-shell --run $SHELL -p";
    };

    users.defaultUserShell = pkgs.zsh;

    environment.shells = with pkgs; [ zsh ];

    users.users.${VARS.userSettings.username} = {
      shell = pkgs.zsh;
    };
  };
}
