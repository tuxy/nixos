{ self, inputs, ... }:
{
  flake.nixosModules.flatpaks =
    { ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          "com.google.AndroidStudio"
          "com.bambulab.BambuStudio"
        ];

        overrides = {
          settings = {
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
