{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.hax =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.hax
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      configJson = builtins.toJSON {
        theme = "dark";
        compact.threshold = 80;
        tool_output_cap = 32768;
        system_prompt_append = "@soul.md";
        # provider = "llama.cpp";            # e.g. a local llama-server
        # providers.<id>.* = { ... };        # custom endpoints, api_key_env
        # presets.<name> = { ... };          # role presets, per-role prompts
      };

      soul = builtins.readFile ./soul.md;

      skills = builtins.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir ./skills));

      haxConfigDir = pkgs.runCommand "hax-config" { } (
        ''
          mkdir -p $out/hax/skills
          cp ${pkgs.writeText "config.json" configJson} $out/hax/config.json
          cp ${pkgs.writeText "soul.md" soul} $out/hax/soul.md
        ''
        + lib.concatMapStringsSep "\n" (name: ''
          cp -r ${./skills}/${name} $out/hax/skills/${name}
        '') skills
      );
    in
    {
      packages.hax = inputs.wrapper-modules.lib.evalPackage [
        { inherit pkgs; }
        (
          {
            wlib,
            lib,
            ...
          }:
          {
            imports = [ wlib.modules.default ];
            package = inputs.llm-agents.packages.${system}.hax;
            env.XDG_CONFIG_HOME = haxConfigDir;
          }
        )
      ];
    };
}
