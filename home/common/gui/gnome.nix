{ pkgs, lib, pkgs-unstable, ... }:
{
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "variable-refresh-rate" "scale-monitor-framebuffer" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnomee/shell/extensions/dash-to-dock" = {
      multi-monitor = true;
      isolate-montiros = true;
      show-apps-at-top = true;
      show-mounts-network = true;
      isolate-locations = true;
      custom-theme-shrink = true;
      intellihide-mode = "ALL_WINDOWS";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "code.desktop"
        "org.telegram.desktop.desktop"
        "discord.desktop"
        "spotify.desktop"
        "plexmediaplayer.desktop"
        "org.gnome.Nautilus.desktop"
        "dev.warp.Warp.desktop"
      ];

      disable-user-extensions = false;
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.transparent-topbar # not compatible gnome 46.1
    gnomeExtensions.tray-icons-reloaded
    # gnomeExtensions.wireless-hid not working
    gnomeExtensions.dash-to-dock
    gnome.adwaita-icon-theme

  ];

  gtk = {
    enable = true;
    theme = {
      # name = "Orchis-Dark-Nord";
      # package = (pkgs-unstable.orchis-theme.override { tweaks = [ "solid" "nord" ]; });
      name = "WhiteSur-Dark";
      package = (pkgs.whitesur-gtk-theme.override { iconVariant = "gnome"; nautilusStyle = "glassy"; });
    };

    # Breaks some icons... ):
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
