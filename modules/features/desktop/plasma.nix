{
  self,
  inputs,
  ...
}:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.plasma =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
      ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      # services.xserver.enable = true;

      home-manager = {
        backupFileExtension = "bak";
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.stylix.homeModules.stylix
        ];
        users.${profile.name} = {
          home.stateVersion = "25.11";
          programs.plasma.enable = true;
        };
      };
    };
}
