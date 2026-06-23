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
      appWorkUtils = pkgs.fetchsvn {
        url = "svn://svn.appwork.org/utils";
        rev = "4705";
        hash = "sha256-lbVanbvqkUCEQHNDLFSmf/43SkDlHyGy62J74ha+7xM=";
      };

      jdBrowser = pkgs.fetchsvn {
        url = "svn://svn.jdownloader.org/jdownloader/browser";
        rev = "52919";
        hash = "sha256-4x2e3zx+kSMsi3HPt93ugZ84NaUx4q0lhlOjULthLrw=";
      };

      jdTrunk = pkgs.fetchsvn {
        url = "svn://svn.jdownloader.org/jdownloader/trunk";
        rev = "52919";
        hash = "sha256-BbhdUS0u2/xa6B4AebY6HL34rfDG8SMwBkHEj26kGZo=";
      };

      myJDClient = pkgs.fetchsvn {
        url = "svn://svn.jdownloader.org/jdownloader/MyJDownloaderClient";
        rev = "52919";
        hash = "sha256-NjgOvnCRW+2vlp9H9z1EP8BC5igrQhHc3mnCrSGkewk=";
      };

      jdk = pkgs.jdk;

      desktopItem = pkgs.makeDesktopItem {
        name = "jdownloader2";
        exec = "jdownloader2";
        comment = "Download manager for one-click hosting sites";
        desktopName = "JDownloader 2";
        categories = [ "Network" ];
      };
    in
    {
      packages.jdownloader2 = pkgs.stdenv.mkDerivation {
        pname = "jdownloader2";
        version = "0-unstable";

        dontUnpack = true;

        nativeBuildInputs = with pkgs; [
          ant
          jdk
          makeWrapper
        ];

        buildPhase = ''
          runHook preBuild

          mkdir workspace
          cp -r ${jdTrunk} workspace/JDownloader
          cp -r ${appWorkUtils} workspace/AppWorkUtils
          cp -r ${jdBrowser} workspace/JDBrowser
          cp -r ${myJDClient} workspace/MyJDownloaderClient
          chmod -R u+w workspace

          cd workspace
          ant -Dbasedir=JDownloader -f JDownloader/build/newBuild/build_standalone.xml

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/opt/jdownloader2 $out/bin $out/share
          cp -r JDownloader/standalone/dist/. $out/opt/jdownloader2/

          makeWrapper ${jdk}/bin/java $out/bin/jdownloader2 \
            --run "mkdir -p \$HOME/.jdownloader2" \
            --run "cp -rn $out/opt/jdownloader2/. \$HOME/.jdownloader2/" \
            --add-flags "-Xmx512m" \
            --add-flags "-Duser.dir=\$HOME/.jdownloader2" \
            --add-flags "-jar \$HOME/.jdownloader2/JDownloader.jar"

          cp -r ${desktopItem}/share/applications/. $out/share/applications

          runHook postInstall
        '';

        meta = with lib; {
          description = "Download manager for one-click hosting sites";
          homepage = "https://jdownloader.org/";
          license = licenses.gpl3Plus;
          platforms = platforms.linux;
        };
      };
    };

  flake.nixosModules.jdownloader2 =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.jdownloader2
      ];
    };
}

