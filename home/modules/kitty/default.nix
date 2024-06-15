{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    settings = {
      window_padding_width = "12";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      font_size = "11.0";

      background_opacity = "0.75";

      hide_window_decorations = "yes";
    };

    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "FiraCode";
    };
  };

}
