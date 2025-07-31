{pkgs}:
with pkgs; let
  modifier = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
in {
  Print = ''exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
  XF86AudioMute = "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
  XF86AudioPlay = "exec ${playerctl}/bin/playerctl play";
  XF86AudioPause = "exec ${playerctl}/bin/playerctl pause";
  XF86AudioNext = "exec ${playerctl}/bin/playerctl next";
  XF86AudioPrev = "exec ${playerctl}/bin/playerctl prev";
  XF86AudioRaiseVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
  XF86AudioLowerVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
  XF86MonBrightnessUp = "exec ${xorg.xbacklight} -inc 20";
  XF86MonBrightnessDown = "exec ${xorg.xbacklight} -dec 20";

  "${modifier}+Return" = "exec ${foot}/bin/foot";
  "${modifier}+q" = "kill";

  "${modifier}+${left}" = "focus left; exec $movemouse";
  "${modifier}+${down}" = "focus down; exec $movemouse";
  "${modifier}+${up}" = "focus up; exec $movemouse";
  "${modifier}+${right}" = "focus right; exec $movemouse";

  "${modifier}+Ctrl+${left}" = "move workspace to output left";
  "${modifier}+Ctrl+${down}" = "move workspace to output down";
  "${modifier}+Ctrl+${up}" = "move workspace to output up";
  "${modifier}+Ctrl+${right}" = "move workspace to output right";

  "${modifier}+Shift+${left}" = "move left";
  "${modifier}+Shift+${down}" = "move down";
  "${modifier}+Shift+${up}" = "move up";
  "${modifier}+Shift+${right}" = "move right";

  "${modifier}+c" = "split h";
  "${modifier}+v" = "split v";
  "${modifier}+f" = "fullscreen toggle";

  "${modifier}+0" = "workspace number 10";
  "${modifier}+Shift+0" = "move container to workspace number 10";

  "${modifier}+Shift+r" = "restart";
}
