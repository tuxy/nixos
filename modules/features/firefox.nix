{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.firefox =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.firefox;
      };
    };

  perSystem =
    { pkgs, ... }:
    let
      lock-false = {
        Value = false;
        Status = "locked";
      };
      lock-empty-string = {
        Value = "";
        Status = "locked";
      };
    in
    {
      packages.firefox = pkgs.wrapFirefox pkgs.firefox.unwrapped {
        extraPolicies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DontCheckDefaultBrowser = true;
          DisablePocket = true;
          SearchBar = "unified";

          Preferences = {
            "extensions.pocket.enabled" = lock-false;
            "browser.newtabpage.pinned" = lock-empty-string;
            "browser.topsites.contile.enabled" = lock-false;
            "browser.newtabpage.activity-stream.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          };

          ExtensionSettings =
            with builtins;
            let
              extension = shortId: uuid: {
                name = uuid;
                value = {
                  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                  installation_mode = "forced_installed";
                };
              };
            in
            listToAttrs [
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
              (extension "sponsorblock" "sponsorBlocker@ajay.app")
              (extension "darkreader" "addon@darkreader.org")
              (extension "dearrow" "deArrow@ajay.app")
              (extension "download-with-jdownloader" "{03e07985-30b0-4ae0-8b3e-0c7519b9bdf6}")
              (extension "downthemall" "{DDC359D1-844A-42a7-9AA1-88A850A938A8}")
              (extension "new-tab-override" "newtaboverride@agenedia.com")
              (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
              (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
              (extension "urls-list" "{88664789-f91e-40e1-adb9-e4e9a8c48867}")
              (extension "video-downloadhelper" "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}")
            ];
        };
      };
    };
}
