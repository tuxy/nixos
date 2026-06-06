{ self, inputs, ... }:
{
  flake.nixosModules.flatpaks =
    { ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [ "com.google.AndroidStudio" ];
      };
    };
}
