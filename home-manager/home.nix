{...}: {
  home-manager.users.tuxy = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ./dconf.nix
      ./packages.nix
      ./chromium.nix
      ./neovim/neovim.nix
      ./shell.nix
      ./vscode.nix
    ];

    home = {
      username = "tuxy";
      homeDirectory = "/home/tuxy";

      stateVersion = "24.11";
    };

    programs.git.enable = true;
  };
}
