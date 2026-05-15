{
  self,
  inputs,
  ...
}:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
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

          # nix-to-kdl conversion example (line 628): https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/lib/lib.nix

          spawn-at-startup = [
            (lib.getExe noctalia-shell)
          ];

          spawn-sh-at-startup = [
            "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"
          ];

          hotkey-overlay.skip-at-startup = _: { };

          window-rules = [
            {
              geometry-corner-radius = 12;
              clip-to-geometry = true;
            }
            {
              match = _: {
                props = {
                  title = "^Authentication Required$";
                };
              };
              open-floating = true;
            }
            {
              match = _: {
                props = {
                  title = "^Eddie - Message$";
                };
              };
              open-floating = true;
            }

          ];

          input.touchpad = {
            tap = _: { };
            natural-scroll = _: { };
          };

          layout = {
            gaps = 12;
            focus-ring = {
              width = 3;
              active-color = "#FFC799";
              inactive-color = "#505050";
            };
            preset-column-widths = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
          };

          overview = {
            zoom = 0.4;
          };

          #preset-column-widths = [
          #  {
          #    proportion = 0.3333;
          #  }
          #  {
          #    proportion = 0.5;
          #  }
          #  {
          #    proportion = 0.6667;
          #  }
          #];

          binds = {
            "Mod+T".spawn = "${lib.getExe pkgs.alacritty}";
            "Mod+D".spawn-sh = "${lib.getExe noctalia-shell} ipc call launcher toggle";

            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+Shift+F".fullscreen-window = _: { };
            "Mod+V".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };
            "Mod+Tab".toggle-overview = _: { };

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

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;

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
            "Mod+I".spawn-sh = "${lib.getExe noctalia-shell} ipc call lockScreen lock";
            "Mod+R".switch-preset-column-width = _: { };
          };
        };
      };
    };
}
