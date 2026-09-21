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
        self.nixosModules.niri
        self.nixosModules.mime
        self.nixosModules.thunar
      ];

      stylix = {
        enable = true;
        autoEnable = true;
        image = ./wallpapers/starlux.png;
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

      security.polkit.enable = true;
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
        lxqt.lxqt-policykit
        alacritty
        ueberzugpp
        xwayland-satellite
        xwayland
        wdisplays
        gpu-screen-recorder
        gpu-screen-recorder-gtk
        libva-utils
      ];

      environment.sessionVariables = {
        XDG_DATA_DIRS = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        ];
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libva
          libva-vdpau-driver
        ];
      };
      programs.dconf.enable = true;

      # gpu-screen-recorder needs gsr-kms-server with CAP_SYS_ADMIN for KMS access
      security.wrappers.gsr-kms-server = {
        source = "${lib.getBin pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
        capabilities = "cap_sys_admin+ep";
        owner = "root";
        group = "root";
      };

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
