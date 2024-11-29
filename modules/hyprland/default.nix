{ config, pkgs, lib, inputs, VARS, ... }:
with lib; let
  cfg = config.modules.nixos.hyprland;
in
{
  options.modules.nixos.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };


  config = mkIf cfg.enable {

    services.xserver = {
      enable = true;

      # Configure keymap in X11
      xkb.layout = "ch";
      xkb.variant = "de";

      displayManager = {
        gdm.enable = true;
      };

    };

    # security = {
    #   polkit.enable = true;
    #   pam.services.ags = { };
    # };

    services.libinput.enable = true;
    programs.dconf.enable = true;

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      nautilus-python
      nautilus
      pavucontrol
      brightnessctl
      anyrun
      swayosd
      playerctl
      swayosd
      xwayland
      wayland-protocols
      hyprlock
    ];

    # services.xserver.displayManager.startx.enable = true;
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-gtk
    #   ];
    # };

    # systemd = {
    #   user.services.polkit-gnome-authentication-agent-1 = {
    #     description = "polkit-gnome-authentication-agent-1";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #       Restart = "on-failure";
    #       RestartSec = 1;
    #       TimeoutStopSec = 10;
    #     };
    #   };
    # };

    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      gnome = {
        evolution-data-server.enable = true;
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
      };
    };
  };
}
