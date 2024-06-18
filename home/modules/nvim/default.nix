{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  home.packages = with pkgs; [
    neovide
    ripgrep # Needed by telescope to search across whole project
    wl-clipboard
  ];

  xdg.configFile."nvim".source = ./config; # Create a symlink to ~/nvim

  #home.file.".config/nvim" = {
  #  source = ./config;
  #  recursive = true; # Ensure the whole directory and its contents are copied
  #};

  # Bug: this is removed from PATH when logging out... workaround is in `mason.lua`, PATH = "prepend" instead of "skip"
  #home.sessionPath = [
  #  "$HOME/.local/share/nvim/mason/bin" # Add lsp binaries to path
  #];

}
