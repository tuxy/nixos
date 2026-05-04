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
    {
      packages.mpv = inputs.wrapper-modules.wrappers.mpv.wrap {
        inherit pkgs;
        script.modernz.path = pkgs.mpvScripts.modernz;
      };
    };
}
