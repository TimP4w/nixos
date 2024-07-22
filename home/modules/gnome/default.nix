{ pkgs, lib, pkgs-unstable, ... }:
{
  imports = [ ./dconf.nix ];

  home.packages = with pkgs; [
    # gnomeExtensions.tray-icons-reloaded
    # gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator # appindicatorsupport@rgcjonas.gmail.com
    gnomeExtensions.dash2dock-lite # dash2dock-lite@icedman.github.com
    gnomeExtensions.mpris-label # "mprisLabel@moon-0xff.github.com"
    gnomeExtensions.quake-terminal # "quake-terminal@diegodario88.github.io"
    gnomeExtensions.tiling-assistant # "tiling-assistant@leleat-on-github"
    gnomeExtensions.blur-my-shell # "blur-my-shell@aunetx"
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
      gtk-application-prefer-dark-theme = "1";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
    };
  };
}
