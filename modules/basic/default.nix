{ config, pkgs, lib, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.basic;
in
{
  options.modules.nixos.basic = {
    enable = mkEnableOption "Enable Basic Config";
  };

  config = mkIf cfg.enable {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.variables = {
      NIXOS_CONFIG_DIR = VARS.hostSettings.configDir;
    };

    # Basic packages
    environment.systemPackages = with pkgs; [
      htop
      git
      vim
      wget
      unzip
      curl
      parted
    ];

    ## Locale
    # Set your time zone.
    time.timeZone = "Europe/Zurich"; # TODO: set in variables

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8"; # TODO: set in variables
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_CH.UTF-8";
      LC_IDENTIFICATION = "de_CH.UTF-8";
      LC_MEASUREMENT = "de_CH.UTF-8";
      LC_MONETARY = "de_CH.UTF-8";
      LC_NAME = "de_CH.UTF-8";
      LC_NUMERIC = "de_CH.UTF-8";
      LC_PAPER = "de_CH.UTF-8";
      LC_TELEPHONE = "de_CH.UTF-8";
      LC_TIME = "de_CH.UTF-8";
    };
  };
}
