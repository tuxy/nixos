{ lib, ... }:
{
  options.flake.diskoConfigurations = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config = {
    systems = [
      "x86_64-linux"
    ];
  };
}
