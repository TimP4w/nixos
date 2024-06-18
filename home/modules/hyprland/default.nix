{ pkgs, inputs, lib, pkgs-unstable, ... }:
{
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
  ];

  programs.anyrun = {
    enable = true;
    config = {

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        #randr
        dictionary
        translate
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { absolute = 800; };
      height = { absolute = 0; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;
    };
    extraCss = builtins.readFile (./. + "/style-dark.css"); # https://github.com/fufexan/dotfiles/blob/f796be6592d2ca832edec51e5837e6172ca7f168/home/programs/anyrun/default.nix#L10
    extraConfigFiles."shell.ron".text = ''
      Config(
        shell: kitty,
      )
    '';
  };

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1;
    NIXOS_OZONE_WL = 1;

  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      debug = {
        overlay = false;
      };

      monitor = [
        "DP-3,2560x1440@165,0x0,1"
        "DP-1,2560x1440@165,2560x0,1"
        # ",preferred,auto,1"
      ];

      exec-once = [
        # "kitty"
      ];

      cursor = {
        no_hardware_cursors = true;
        no_break_fs_vrr = true;
        min_refresh_rate = 24;
      };

      general = {

        gaps_in = 4;
        gaps_out = 12;
        border_size = 2;

        #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        #col.inactive_border = "rgba(595959aa)"; # transparent

        allow_tearing = false;
        resize_on_border = true;
        layout = "dwindle";

      };

      decoration = {
        rounding = 8;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 0.95;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        # col.shadow = "rgba(1a1a1aee)";

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 3;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];

      };


      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      #master = {
      #  new_is_master = true;
      #};

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
        vfr = true;
        vrr = 1;
      };

      input = {
        kb_layout = "ch";
        kb_variant = "de";
        #kb_model = "";
        #kb_options = "";
        #kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = false;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "SUPER, T, exec, kitty"
        "SUPER, C, killactive,"
        "SUPER, M, exit,"
        "SUPER, E, exec, nautilus"
        "SUPER, V, togglefloating,"
        "SUPER, R, exec, anyrun"
        "SUPER, P, pseudo," # dwindle
        "SUPER, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        # Plugins
        "SUPER, K, hyprexpo:expo, toggle"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      windowrulev2 = "suppressevent maximize, class:.*";

      env = [
        "XCURSOR_SIZE,24"
        "WLR_NO_HARDWARE_CURSORS,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,1"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = true; # laptop touchpad
          gesture_fingers = 3; # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };
    };

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };
}
