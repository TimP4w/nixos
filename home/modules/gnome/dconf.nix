# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{

  ###
  # $  dconf dump / > dconf.settings
  # $ nix-run dconf2nix 
  # $ cat dconf.settings | dconf2nix > dconf.nix
  ###

  dconf.settings = {
    "org/gnome/Geary" = {
      run-in-background = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/mutter" = {
      experimental-features = [ "variable-refresh-rate" "scale-monitor-framebuffer" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/resources/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/resources" = {
      binding = "<Control><Alt>Delete";
      command = "resources";
      name = "Resources";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash2dock-lite@icedman.github.com"
        "mprisLabel@moon-0xff.github.com"
        "quake-terminal@diegodario88.github.io"
      ];
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
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.10000000000000003;
      icon-contrast = 0.10000000000000003;
      icon-opacity = 240;
      icon-saturation = 2.7755575615628914e-17;
      legacy-tray-enabled = true;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      background-opacity = 0.8;
      custom-background-color = false;
      dance-urgent-applications = true;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      hide-tooltip = false;
      icon-size-fixed = false;
      isolate-monitors = true;
      isolate-workspaces = false;
      max-alpha = 0.8;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "DP-1";
      preview-size-scale = 0.0;
      running-indicator-style = "DEFAULT";
      transparency-mode = "DEFAULT";
    };

    "org/gnome/shell/extensions/dash2dock-lite" = {
      animate-icons-unmute = true;
      animation-bounce = 0.75;
      animation-fps = 0;
      animation-magnify = 0.2;
      animation-rise = 0.75;
      animation-spread = 0.6;
      apps-icon = true;
      apps-icon-front = true;
      autohide-dash = true;
      autohide-speed = 0;
      background-color = mkTuple [ 1.0 1.0 1.0 0.16326530277729034 ];
      blur-background = true;
      blur-resolution = 0;
      border-color = mkTuple [ 6.666666828095913e-3 6.666666828095913e-3 6.666666828095913e-3 1.0 ];
      border-radius = 3;
      border-thickness = 0;
      calendar-icon = false;
      clock-icon = false;
      clock-style = 0;
      customize-label = true;
      customize-topbar = true;
      debug-visual = false;
      dock-padding = 0.174419;
      downloads-icon = true;
      edge-distance = 0.541463;
      favorites-only = false;
      icon-effect = 0;
      icon-resolution = 0;
      icon-shadow = false;
      icon-size = 0.2;
      icon-spacing = 0;
      items-pullout-angle = 0.5;
      label-border-radius = 0.0;
      label-border-thickness = 0;
      max-recent-items = 1;
      mounted-icon = true;
      msg-to-ext = "";
      multi-monitor-preference = 1;
      notification-badge-color = mkTuple [ 0.6933333277702332 2.3111088667064905e-3 2.3111088667064905e-3 1.0 ];
      notification-badge-size = 0;
      notification-badge-style = 0;
      open-app-animation = true;
      panel--mode = false;
      panel-mode = false;
      preferred-monitor = 0;
      pressure-sense = false;
      pressure-sense-sensitivity = 0.4;
      running-indicator-color = mkTuple [ 1.0 1.0 1.0 1.0 ];
      running-indicator-size = 0;
      running-indicator-style = 1;
      scroll-sensitivity = 0.4;
      separator-thickness = 0;
      shrink-icons = 1;
      topbar-blur-background = true;
      topbar-border-thickness = 0;
      topbar-foreground-color = mkTuple [ 1.0 1.0 1.0 1.0 ];
      trash-icon = true;
    };


    "org/gnome/shell/extensions/mpris-label" = {
      album-size = 60;
      divider-string = " | ";
      extension-place = "center";
      first-field = "xesam:artist";
      last-field = "xesam:title";
      left-padding = 0;
      right-padding = 0;
      second-field = "";
      show-icon = "left";
      symbolic-source-icon = false;
      use-album = true;
      volume-control-scheme = "application";
    };

    "org/gnome/shell/extensions/quake-terminal" = {
      animation-time = 125;
      monitor-screen = 1;
      render-on-current-monitor = true;
      terminal-id = "kitty.desktop";
      terminal-shortcut = "<Super>Return";
      vertical-size = 60;
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      applications = "[]";
      icon-brightness = 0;
      icon-contrast = 0;
      icon-margin-horizontal = 0;
      icon-saturation = 0;
      invoke-to-workspace = true;
      wine-behavior = true;
    };

  };
}
