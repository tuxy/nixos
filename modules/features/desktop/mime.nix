{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.mime =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xdg-utils
      ];

      xdg.mime.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "application/pdf" = [ "org.kde.okular.desktop" ];
        "x-scheme-handler/mpv" = [ "open-in-mpv.desktop" ];
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
}
