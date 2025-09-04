{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];

  # Enable gnome-keyring & polkit
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Enable sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd \"sway --unsupported-gpu\"";
        user = "tuxy";
      };
      default_session = initial_session;
    };
  };

  # Show available greet options
  environment.etc."greetd/environments".text = ''
    sway
    bash
    zsh
  '';
}
