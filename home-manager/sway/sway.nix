{
  lib,
  pkgs,
  ...
}: {
  programs.waybar.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        {command = "lxqt-policykit-agent";}
      ];
      keybindings = lib.mkOptionDefault (import ./keybinds.nix {inherit pkgs;});
    };
  };
}
