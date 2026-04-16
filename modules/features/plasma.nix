{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.plasma =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      services.xserver.enable = true;

      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
        polarity = "dark";
      };
    };
}
