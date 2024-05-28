{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.ld;
in
{
  options.modules.nixos.ld = {
    enable = mkEnableOption "Enable nix-ld dynamic linking";
  };

  config = mkIf cfg.enable {
    # Needed for neovim Mason / LSP installer
    # Allows dynamic linking for downloaded binaries
    programs.nix-ld.enable = true;
  };
}
