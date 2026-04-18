{
  self,
  inputs,
  ...
}:
let
  profile = self.proiles.tuxy;
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
      services.xserver.enable = true;

      home-manager = {
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.stylix.homeModules.stylix
        ];
        users.${profile.name} = {
          home.stateVersion = "25.11";

          stylix = {
            enable = true;
            autoEnable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
            polarity = "dark";
          };

          programs.plasma = {
            enable = true;
          };
        };
      };
    };
}
