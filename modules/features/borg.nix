{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.borg =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.borgbackup
        pkgs.borgmatic
      ];

      services.borgmatic = {
        enable = true;

        configurations.central-server-backup = {
          source_directories = [
            "/home/${profile.name}/Documents"
            "/home/${profile.name}/Pictures"
            "/home/${profile.name}/Games"
          ];

          repositories = [
            {
              path = "ssh://root@server01.tuxy.party/data/backups";
              label = "default";
            }
          ];

          compression = "auto,zstd";

          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 6;

          checks = [
            { name = "repository"; }
            { name = "archives"; }
          ];
          check_last = 3;
        };
      };
    };
}

