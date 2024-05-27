{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bottles
    lutris
  ];
}
