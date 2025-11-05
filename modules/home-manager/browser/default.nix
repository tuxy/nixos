{
  inputs,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    profiles.tuxy = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "np" ];
        };
        "SearXNG" = {
          default = true;
          urls = [
            {
              template = "https://priv.au/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        tridactyl
        youtube-shorts-block
        vimium
      ];

      containersForce = true;
      search.force = true;
    };
  };
}
