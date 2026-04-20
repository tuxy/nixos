{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.live-iso = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.liveIsoConfiguration
    ];
  };
}