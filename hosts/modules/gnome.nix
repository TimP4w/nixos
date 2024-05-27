{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb.layout = "ch";
    xkb.variant = "fr_nodeadkeys";

    # Deprecated 23.11
    #layout = "ch"; # xkb.layout = "ch";
    #xkbVariant = "fr_nodeadkeys"; # xkb.variant = "fr_nodeadkeys";
    # libinput.enable = true; #   services.libinput.enable = true;


    displayManager = {
      gdm.enable = true;
    };

    desktopManager = {
      gnome.enable = true;
    };
  };

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs;
    [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-initial-setup
    # gnome-contacts
    # gnome-characters
  ]);



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
