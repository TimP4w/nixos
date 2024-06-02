{ pkgs, lib, ... }:
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
      name = "Orchis-Dark-Nord";
      package = (pkgs.orchis-theme.override { tweaks = [ "solid" "nord" ]; });
    };

    iconTheme = {
      name = "kora";
      package = pkgs.kora-icon-theme;
    };

    #cursorTheme = {
    #  name = "Adwaita";
    #  package = pkgs.gnome.adwaita-icon-theme;
    #};

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
