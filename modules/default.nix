{
  docker = import ./docker;
  audio = import ./audio;
  basic = import ./basic;
  desktop = import ./desktop;
  gaming = import ./gaming;
  gnome = import ./gnome;
  plasma = import ./plasma;

  grub = import ./grub;
  ld = import ./ld;
  network = import ./network;
  nvidia = import ./nvidia;
  zsh = import ./zsh;
  password-manager = import ./password-manager;
  logitech = import ./logitech;
  # hyprland = import ./hyprland;
  bluetooth = import ./bluetooth;
  wayland = import ./wayland;
  plymouth = import ./plymouth;
}
