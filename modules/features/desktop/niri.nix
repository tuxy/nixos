{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

      security.polkit.enable = true;
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
        lxqt.lxqt-policykit
      ];

      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
        polarity = "dark";
      };
    };

  perSystem =
    {
      pkgs,
      config,
      lib,
      self',
      ...
    }:
    let
      noctalia-shell = self'.packages.noctalia;
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            (lib.getExe noctalia-shell)
          ];

          window-rules = [
            {
              geometry-corner-radius = 12;
              clip-to-geometry = true;
            }
          ];

          input.touchpad = [
            "tap"
            "natural-scroll"
          ];

          layout.gaps = 5;

          binds = {
            "Mod+Return".spawn = "${pkgs.alacritty}";
            "Mod+S".spawn-sh = "${lib.getExe noctalia-shell} ipc call launcher toggle";

            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+G".fullscreen-window = _: { };
            "Mod+Shift+F".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            "Mod+1".focus-workspace = "w0";
            "Mod+2".focus-workspace = "w1";
            "Mod+3".focus-workspace = "w2";
            "Mod+4".focus-workspace = "w3";
            "Mod+5".focus-workspace = "w4";
            "Mod+6".focus-workspace = "w5";
            "Mod+7".focus-workspace = "w6";
            "Mod+8".focus-workspace = "w7";
            "Mod+9".focus-workspace = "w8";
            "Mod+0".focus-workspace = "w9";

            "Mod+Shift+1".move-column-to-workspace = "w0";
            "Mod+Shift+2".move-column-to-workspace = "w1";
            "Mod+Shift+3".move-column-to-workspace = "w2";
            "Mod+Shift+4".move-column-to-workspace = "w3";
            "Mod+Shift+5".move-column-to-workspace = "w4";
            "Mod+Shift+6".move-column-to-workspace = "w5";
            "Mod+Shift+7".move-column-to-workspace = "w6";
            "Mod+Shift+8".move-column-to-workspace = "w7";
            "Mod+Shift+9".move-column-to-workspace = "w8";
            "Mod+Shift+0".move-column-to-workspace = "w9";

            "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe noctalia-shell} ipc call volume increase";
            "XF86AudioLowerVolume".spawn-sh = "${lib.getExe noctalia-shell} ipc call volume decrease";
            "XF86AudioMute".spawn-sh = "${lib.getExe noctalia-shell} ipc call volume muteOutput";

            "XF86MonBrightnessUp".spawn-sh = "${lib.getExe noctalia-shell} ipc call brightness increase";
            "XF86MonBrightnessDown".spawn-sh = "${lib.getExe noctalia-shell} ipc call brightness decrease";

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Print".screenshot = _: { };
            "Mod+Shift+E".quit = _: { };
            "Mod+Shift+L".spawn-sh = "${lib.getExe noctalia-shell} ipc call lockScreen lock";
          };
        };
      };
    };
}
