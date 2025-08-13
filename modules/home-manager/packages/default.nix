{pkgs, ...}: {
  # If this is imported instead of the sections, it generally means that it's a desktop.
  # Uncategorised desktop apps go here
  home.packages = with pkgs; [
    anki
  ];

  # Import all the other modules
  imports = [
    ./cli
    ./dev
    ./media
    ./gaming
    ./system
    ./education
  ];
}
