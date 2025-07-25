{
  gnome = import ./gnome;
  common = import ./common;
  brave = import ./browsers/brave.nix;
  development = import ./development;
  kubernetes = import ./development/kubernetes.nix;
  terraform = import ./development/terraform.nix;
  go = import ./development/go.nix;
  gaming = import ./gaming;
  kitty = import ./kitty;
  #nvim = import ./nvim;
  ssh = import ./ssh;
  zsh = import ./zsh;
  git = import ./git;
  rclone = import ./rclone;

#../../modules/hyprland
}
