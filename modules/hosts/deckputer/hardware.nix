{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.deckputerHardware = ./_hardware-configuration.nix;
}
