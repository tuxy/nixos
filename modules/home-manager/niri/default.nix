{ pkgs, ... }:
{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    targets.firefox = {
      enable = true;
      profileNames = [ "tuxy" ];
    };
  };

  home.file.".config/niri/config.kdl".source = ./config.kdl;

  programs.i3bar-river = {
    enable = true;
    settings = {
      height = 20;
      command = "i3status";
    };
  };

  programs.bemenu = {
    enable = true;
    settings = {
      line-height = 20;
    };
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    modules = {
      "wireless _first_" = {
        position = 1;
        settings = {
          format_up = "W: (%quality at %essid, %bitrate) %ip";
          format_down = "W: down";
        };
      };

      "ethernet _first_" = {
        position = 2;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };

      "volume master" = {
        position = 3;
        settings = {
          format = "v: %volume";
          format_muted = "v: muted (%volume)";
          device = "pulse:1";
        };
      };

      "battery all" = {
        position = 4;
        settings.format = "%status %percentage %remaining";
      };

      "tztime local" = {
        position = 5;
        settings.format = "%Y-%m-%d %H:%M";
      };
    };
  };
}
