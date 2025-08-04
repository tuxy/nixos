{
  lib,
  pkgs,
  ...
}: let
  color = import ./color.nix {};

  window_bg_color = color.h_background;
  view_bg_color = color.h_bright_black;
  view_fg_color = color.h_foreground;
  accent_bg_color = color.h_bright_blue;
  accent_fg_color = color.h_foreground;
  urgent_bg_color = color.h_bright_red;
  urgent_fg_color = color.h_foreground;
in {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        {command = "lxqt-policykit-agent";}
      ];
      bars = [
        {command = "${pkgs.waybar}/bin/waybar";}
      ];
      keybindings = lib.mkOptionDefault (import ./keybinds.nix {inherit pkgs;});
      colors = {
        background = window_bg_color;
        focused = {
          border = accent_bg_color;
          background = accent_bg_color;
          text = accent_fg_color;
          indicator = accent_bg_color;
          childBorder = accent_bg_color;
        };
        focusedInactive = {
          border = view_bg_color;
          background = view_bg_color;
          text = view_fg_color;
          indicator = view_bg_color;
          childBorder = view_bg_color;
        };
        unfocused = {
          border = view_bg_color;
          background = view_bg_color;
          text = view_fg_color;
          indicator = view_bg_color;
          childBorder = view_bg_color;
        };
        urgent = {
          border = urgent_bg_color;
          background = urgent_bg_color;
          text = urgent_fg_color;
          indicator = urgent_bg_color;
          childBorder = urgent_bg_color;
        };
        placeholder = {
          border = accent_bg_color;
          background = accent_bg_color;
          text = accent_fg_color;
          indicator = accent_bg_color;
          childBorder = accent_bg_color;
        };
      };
    };
  };
}
