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
      experimental-features = [ "xwayland-native-scaling" "variable-refresh-rate" "scale-monitor-framebuffer"  ];
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
        "mprisLabel@moon-0xff.github.com"
        "clipboard-history@alexsaveau.dev"
        # "executor@raujonas.github.io"
        "dash2dock-lite@icedman.github.com"
        "quake-terminal@diegodario88.github.io"
        "blur-my-shell@aunetx"
        # "tiling-assistant@leleat-on-github"
        "solaar-extension@sidevesh"
        "gsconnect@andyholmes.github.io"
        # "compiz-alike-magic-lamp-effect@hermes83.github.com" # Looks nice, breaks a lot of stuff
        "hidetopbar@mathieu.bidon.ca"
        "tilingshell@ferrarodomenico.com"
      ];
      favorite-apps = [
        "brave-browser.desktop"
        "code.desktop"
        # "beekeeper-studio.desktop"
        "org.telegram.desktop.desktop"
        "discord.desktop"
        "page.kramo.Cartridges.desktop"
        "slack.desktop"
        "dev.vencord.Vesktop.desktop"
        "spotify.desktop"
        "plexmediaplayer.desktop"
        "org.gnome.Nautilus.desktop"
        "dev.warp.Warp.desktop"
      ];
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.1;
      icon-contrast = 0.1;
      icon-opacity = 240;
      # icon-saturation = 2.7755575615628914e-17;
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
      background-color = mkTuple [ 0.0 0.0 0.0 0.0 ];
      blur-background = false;
      blur-resolution = 0;
      # border-color = mkTuple [ 6.666666828095913e-3 6.666666828095913e-3 6.666666828095913e-3 1.0 ];
      border-radius = 3;
      border-thickness = 0;
      calendar-icon = false;
      clock-icon = false;
      clock-style = 0;
      customize-label = true;
      customize-topbar = false;
      debug-visual = false;
      dock-padding = 0.18;
      downloads-icon = true;
      edge-distance = 0.32;
      favorites-only = false;
      icon-effect = 0;
      icon-resolution = 0;
      icon-shadow = true;
      icon-size = 0.2;
      icon-spacing = 0.2;
      items-pullout-angle = 0.0;
      label-border-radius = 3.0;
      label-border-thickness = 0;
      max-recent-items = 1;
      mounted-icon = true;
      msg-to-ext = "";
      multi-monitor-preference = 1;
      notification-badge-color = mkTuple [ 0.0 0.5 1.0 1.0 ];
      notification-badge-size = 2;
      notification-badge-style = 1;
      open-app-animation = true;
      panel-mode = false;
      preferred-monitor = 0;
      pressure-sense = false;
      pressure-sense-sensitivity = 0.4;
      running-indicator-color = mkTuple [ 1.0 1.0 1.0 1.0 ];
      running-indicator-size = 0;
      running-indicator-style = 1;
      scroll-sensitivity = 0.4;
      separator-thickness = 2;
      separator-color = mkTuple [ 1.0 1.0 1.0 1.0 ];
      shrink-icons = 1;
      topbar-blur-background = false;
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
      terminal-id = "dev.warp.Warp.desktop";
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

    "org/gnome/shell/extensions/tiling-assistant" = {
      activate-layout0 = [ ];
      activate-layout1 = [ ];
      activate-layout2 = [ ];
      activate-layout3 = [ ];
      active-window-hint = 1;
      active-window-hint-color = "rgb(8,96,242)";
      auto-tile = [ ];
      center-window = [ ];
      debugging-free-rects = [ ];
      debugging-show-tiled-rects = [ ];
      default-move-mode = 0;
      dynamic-keybinding-behavior = 0;
      import-layout-examples = false;
      last-version-installed = 47;
      maximize-with-gap = false;
      restore-window = [ "<Super>Down" ];
      search-popup-layout = [ ];
      single-screen-gap = 8;
      tile-bottom-half = [ "<Super>KP_2" ];
      tile-bottom-half-ignore-ta = [ ];
      tile-bottomleft-quarter = [ "<Super>KP_1" ];
      tile-bottomleft-quarter-ignore-ta = [ ];
      tile-bottomright-quarter = [ "<Super>KP_3" ];
      tile-bottomright-quarter-ignore-ta = [ ];
      tile-edit-mode = [ "<Shift><Alt>l" ];
      tile-left-half = [ "<Super>Left" "<Super>KP_4" ];
      tile-left-half-ignore-ta = [ ];
      tile-maximize = [ "<Super>Up" "<Super>KP_5" ];
      tile-maximize-horizontally = [ ];
      tile-maximize-vertically = [ ];
      tile-right-half = [ "<Super>Right" "<Super>KP_6" ];
      tile-right-half-ignore-ta = [ ];
      tile-top-half = [ "<Super>KP_8" ];
      tile-top-half-ignore-ta = [ ];
      tile-topleft-quarter = [ "<Super>KP_7" ];
      tile-topleft-quarter-ignore-ta = [ ];
      tile-topright-quarter = [ "<Super>KP_9" ];
      tile-topright-quarter-ignore-ta = [ ];
      toggle-always-on-top = [ ];
      toggle-tiling-popup = [ ];
      window-gap = 8;
    };
  };
}
