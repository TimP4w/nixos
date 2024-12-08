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
    gnomeExtensions.solaar-extension # "solaar-extension@sidevesh"
    gnomeExtensions.clipboard-history 
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.gsconnect
    gnomeExtensions.hide-top-bar
    adwaita-icon-theme
    gnome-themes-extra
    imagemagick # Needed by dash2dock-lite
  ];

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 28;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    # theme = {
    #   # name = "Orchis-Dark-Nord";
    #   # package = (pkgs-unstable.orchis-theme.override { tweaks = [ "solid" "nord" ]; });
    #   name = "WhiteSur-Dark";
    #   package = (pkgs.whitesur-gtk-theme.override { iconVariant = "gnome"; nautilusStyle = "glassy"; });
    # };

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

    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = "1";
    # };
  };
}
