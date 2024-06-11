{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.password-manager;
in
{
  options.modules.nixos.password-manager = {
    enable = mkEnableOption "Enable Password Manager (1Password)";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password = {
        enable = true;
      };

      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ VARS.userSettings.username ];
      };

    };
  };
}
