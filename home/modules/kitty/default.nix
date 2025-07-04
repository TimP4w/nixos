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

      background_opacity = "0.95";

      hide_window_decorations = "yes";

      tab_bar_style = "powerline";
      scrollback_lines = "8000";
      paste_actions = "quote-urls-at-prompt";
      strip_trailing_spaces = "never";
      select_by_word_characters = "@-./_~?&=%+#";
      show_hyperlink_targets = "yes";
      remote_kitty = "if-needed";
      share_connections = "yes";
      enabled_layouts = "splits,stack";
    };

    font = {
      # package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode";
    };
  };

}
