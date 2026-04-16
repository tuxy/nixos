{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.deskputer = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.deskputerHardware
      self.nixosModules.deskputerConfiguration
    ];
  };
}
