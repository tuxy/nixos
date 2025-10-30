{...}: {
  imports = [
    ./sway.nix
    ./gtk.nix
    ./qt.nix

    # Imports xdg mime default apps
    ../xdg
  ];
}
