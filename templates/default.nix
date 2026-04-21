{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.HOSTNAME = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.HOSTNAMEConfiguration
    ];
  };
}
