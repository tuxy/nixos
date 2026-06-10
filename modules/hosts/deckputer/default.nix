{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.deckputer = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.deckputerConfiguration
    ];
  };
}
