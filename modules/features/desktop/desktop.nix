{ self, inputs, ... }:
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
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.niri
        self.nixosModules.thunar
      ];

      stylix = {
        enable = true;
        autoEnable = true;
        image = ./wallpapers/wall.png;
        base16Scheme = ./base16-vesper.yaml;
        polarity = "dark";
        icons = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          dark = "Adwaita";
          light = "Adwaita";
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
          gtk4.theme = null;
        };
      };

      security.polkit.enable = true;
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
        lxqt.lxqt-policykit
        alacritty
        xwayland-satellite
        xwayland
      ];

      hardware.graphics.enable = true;

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
