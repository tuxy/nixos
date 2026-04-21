{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.thunar
      ];

      stylix = {
        enable = true;
        autoEnable = true;
        image = ./wall.png;
        base16Scheme = ./base16-vesper.yaml;
        polarity = "dark";
        icons = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          dark = "Adwaita-Dark";
          light = "Adwaita-Light";
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        configPackages = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      home-manager.users.${profile.name} = {
        home.username = profile.name;
        home.homeDirectory = "/home/${profile.name}";
        home.stateVersion = "25.11";

        gtk = {
          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };

      security.polkit.enable = true;
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
        lxqt.lxqt-policykit
        alacritty
      ];

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${config.programs.niri.package}/bin/niri-session";
            user = profile.name;
          };
        };
      };
    };
}
