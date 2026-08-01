{ self, inputs, ... }:
{
  flake.nixosModules.pi = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.pi
    ];
  };
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      configDir = ./config;

      listEntries =
        dir: type:
        lib.mapAttrsToList (name: _: configDir + "/${dir}/${name}") (
          lib.filterAttrs (name: t: t == type && name != ".gitkeep") (lib.readDir (configDir + "/${dir}"))
        );

      models =
        if builtins.pathExists (configDir + "/models.json") then configDir + "/models.json" else null;

      piPackage = (inputs.pi.lib.mkCodingAgent {
        inherit pkgs;
        modules = [
          {
            pi.coding-agent = {
              rules = ./config/rules.md;
              inherit models;
              skills = listEntries "skills" "directory";
              extensions = listEntries "extensions" "regular";
              themes = listEntries "themes" "regular";
              promptTemplates = listEntries "promptTemplates" "directory";
              settings = {
                packages = [
                  "npm:pi-subagents"
                  "npm:pi-parallel-agents"
                  "npm:pi-lens"
                  "npm:context-mode"
                  "npm:pi-web-access"
                ];
              };
            };
          }
        ];
      }).package;

    in
    {
      packages.pi = piPackage;
    };
}
