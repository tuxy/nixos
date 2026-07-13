{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      desktopItem = pkgs.makeDesktopItem {
        name = "littlenavmap";
        exec = "littlenavmap";
        icon = "littlenavmap";
        comment = "Free open-source flight planner and moving map for Flight Simulator, X-Plane, and more";
        desktopName = "Little Navmap";
        categories = [ "Simulation" ];
      };
    in
    {
      packages.littlenavmap = pkgs.stdenv.mkDerivation {
        pname = "littlenavmap";
        version = "3.0.18";

        src = pkgs.fetchurl {
          url = "https://github.com/albar965/littlenavmap/releases/download/v3.0.18/LittleNavmap-linux-ubuntu-24.04-3.0.18.tar.xz";
          hash = "sha256-fDGMNDUpCYl3NOHVz3Y0EHATjxZ4aGufGRqE0CaTxcM=";
        };

        dontConfigure = true;
        dontBuild = true;
        dontWrapQtApps = true;

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          makeWrapper
        ];

        buildInputs = with pkgs; [
          stdenv.cc.cc
          glib
          libx11
          libxext
          libxcursor
          libxrandr
          libxi
          libxcb
          libxdamage
          libxfixes
          libxrender
          libxcomposite
          libxinerama
          libxkbcommon
          fontconfig
          freetype
          dbus
          libGL
          alsa-lib
          zlib
          libpng
          libdrm
          libkrb5
          xcbutil
          xcbutilwm
          xcbutilimage
          xcbutilkeysyms
          xcbutilrenderutil
          atk
          at-spi2-atk
          at-spi2-core
          gtk3
          gdk-pixbuf
          pango
          cairo
          qt5.qtbase
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/opt/littlenavmap $out/bin
          cp -r * $out/opt/littlenavmap/
          install -Dm644 $out/opt/littlenavmap/littlenavmap.svg $out/share/icons/hicolor/scalable/apps/littlenavmap.svg
          makeWrapper $out/opt/littlenavmap/littlenavmap $out/bin/littlenavmap \
            --run "mkdir -p \$HOME/.config/ABarthel" \
            --run "cp -rn $out/opt/littlenavmap/little_navmap_db \$HOME/.config/ABarthel/" \
            --run "chmod -R u+w \$HOME/.config/ABarthel/little_navmap_db"
          cp -r ${desktopItem}/share/applications/. $out/share/applications

          runHook postInstall
        '';

        meta = with lib; {
          description = "Free open-source flight planner and moving map for Flight Simulator, X-Plane, and more";
          homepage = "https://albar965.github.io/littlenavmap.html";
          license = licenses.gpl3Plus;
          platforms = platforms.linux;
        };
      };
    };

  flake.nixosModules.littlenavmap =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.littlenavmap
      ];
    };
}
