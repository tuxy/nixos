{
  lib,
  config,
  pkgs,
  ...
}: let
  profile = import ../../user/profile.nix {};
in {
  imports = [
    ../../modules/home-manager/neovim
    ../../modules/home-manager/shell
    ../../modules/home-manager/packages/cli
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = lib.mkDefault profile.name;
    homeDirectory = lib.mkDefault "/home/${profile.name}";

    packages = with pkgs; [
      ncurses # for fixing clear functionality
    ];

    home.activation = {
      # Font fix using https://github.com/nix-community/nix-on-droid/issues/120
      copyFont = let
        font_src = "${
          pkgs.nerdfonts.override {fonts = ["FiraCode"];}
        }/share/fonts/truetype/NerdFonts/Fira Code Regular Nerd Font Complete Mono.ttf";
        font_dst = "${config.home.homeDirectory}/.termux/font.ttf";
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          ( test ! -e "${font_dst}" || test $(sha1sum "${font_src}"|cut -d' ' -f1 ) != $(sha1sum "${font_dst}" |cut -d' ' -f1)) && $DRY_RUN_CMD install $VERBOSE_ARG -D "${font_src}" "${font_dst}"
        '';
    };

    stateVersion = "24.11";
  };
}
