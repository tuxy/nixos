{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.HOSTNAMEHardware = ./_hardware-configuration.nix;
}
