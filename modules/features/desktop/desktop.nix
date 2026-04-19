{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.thunar
      ];
      environment.systemPackages = with pkgs; [
        alacritty
      ];

      services.displayManager.ly.enable = true;
    };
}
