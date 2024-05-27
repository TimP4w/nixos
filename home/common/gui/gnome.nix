{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "code.desktop"
        "org.telegram.desktop.desktop"
        "discord.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
        "warp.desktop" # TODO: check correct name
      ];

      disable-user-extensions = false;
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
      ];
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.transparent-topbar # not compatible gnome 46.1
    gnomeExtensions.tray-icons-reloaded
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
