{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    in
    {
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        inherit settings;
      };
    };
}
