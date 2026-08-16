{ self, inputs, ... }:
{
  flake.nixosModules.flatpaks =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        package = inputs.nixpkgs-flatpak.legacyPackages.${pkgs.stdenv.hostPlatform.system}.flatpak;
        packages = [
          "com.google.AndroidStudio"
          "com.bambulab.BambuStudio"
        ];

        overrides = {
          settings = {
            "com.bambulab.BambuStudio" = {
              Context = {
                sockets = [
                  "wayland"
                  "fallback-x11"
                  "x11"
                ];
              };
              "Session Bus Policy" = {
                "org.freedesktop.Flatpak" = "talk";
              };
              Environment = {
                GDK_BACKEND = "wayland";
              };
            };

            "com.google.AndroidStudio" = {
              Context = {
                sockets = [
                  "wayland"
                  "fallback-x11"
                  "x11"
                ];
              };
              "Session Bus Policy" = {
                "org.freedesktop.Flatpak" = "talk";
              };
              Environment = {
                AWT_TOOLKIT_NAME = "WLToolkit";
                GDK_BACKEND = "wayland";
              };
            };
          };
        };
      };
    };
}
