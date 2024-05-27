{ pkgs, ... }:
{
  # TODO: add clipboard provider!
  home.packages = with pkgs; [
    neovide
    neovim
    ripgrep # Needed by telescope to search across whole project
  ];

  home.file.".config/nvim" = {
    source = ./config;
    recursive = true; # Ensure the whole directory and its contents are copied
  };

  # Bug: this is removed from PATH when logging out... workaround is in `mason.lua`, PATH = "prepend" instead of "skip"
  #home.sessionPath = [
  #  "$HOME/.local/share/nvim/mason/bin" # Add lsp binaries to path
  #];

}
