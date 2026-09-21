# Digilent Adept + WaveForms from prefetched .debs

{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      lib,
      ...
    }:
    let
      # Allowlist: packages + requireFile deb names
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          let
            name = lib.getName pkg;
          in
          name == "digilent-adept"
          || name == "digilent-waveforms"
          || lib.hasPrefix "digilent.adept.runtime_" name
          || lib.hasPrefix "digilent.waveforms_" name;
      };

      # .debs prefetched into store, never downloaded
      debDir = "/home/tuxy/Digilent";

      adeptVersion = "2.30.1";
      waveformsVersion = "3.25.1";

      # requireFile: reuse store copy, else error
      debSrc =
        {
          filename,
          sha256,
          url,
        }:
        pkgs.requireFile {
          name = filename;
          inherit sha256;
          message = ''
            The Digilent .deb file ${filename} is not in the Nix store.

            Download it from ${url} and save it to:

              ${debDir}/${filename}

            Then add it to the store with either:

              nix-prefetch-url file://${debDir}/${filename}

            or:

              nix-store --add-fixed sha256 ${debDir}/${filename}

            and re-run the build.
          '';
        };

      adeptDeb = {
        filename = "digilent.adept.runtime_${adeptVersion}_amd64.deb";
        sha256 = "0wmknrrhgsc2mgxkvmv0a6qj10c36zgknvs37gpk9zy280k1vrg5";
        url = "https://digilent.com/reference/software/adept/start";
      };

      waveformsDeb = {
        filename = "digilent.waveforms_${waveformsVersion}_amd64.deb";
        sha256 = "1lr74wh2kkgdlbra4bxnq1qk2l9i8lqjnp8wiaj054kcfamrm5yj";
        url = "https://digilent.com/reference/software/waveforms/waveforms-3/start";
      };
    in
    {
      # Adept Runtime: libs, firmware, udev rules
      packages.digilent-adept = pkgs.stdenv.mkDerivation {
        pname = "digilent-adept";
        version = adeptVersion;
        src = debSrc adeptDeb;

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          binutils
          gzip
          zstd
        ];
        buildInputs = with pkgs; [
          libusb1
          avahi
          openssl_3
          stdenv.cc.cc.lib
        ];

        dontConfigure = true;
        dontBuild = true;

        unpackPhase = ''
          mkdir -p adept-deb && cd adept-deb
          ar x "$src"
          tar xzf data.tar.gz
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/digilent/adept \
                   $out/share/digilent/adept/data \
                   $out/etc \
                   $out/lib/udev/rules.d \
                   $out/lib/udev

          # Shared libraries
          cp -fd usr/lib/digilent/adept/* $out/lib/digilent/adept/

          # Firmware images + JTAG support data
          cp -r usr/share/digilent/adept/data/* $out/share/digilent/adept/data/

          # udev rules + dftdrvdtch helper
          cp -f etc/udev/rules.d/52-digilent-usb.rules $out/lib/udev/rules.d/
          cp -f usr/lib/udev/dftdrvdtch $out/lib/udev/

          # Config with Nix-store paths baked in
          sed \
            -e "s|^DigilentPath=.*|DigilentPath=$out/share/digilent|" \
            -e "s|^DigilentDataPath=.*|DigilentDataPath=$out/share/digilent/adept/data|" \
            etc/digilent-adept.conf > $out/etc/digilent-adept.conf

          # udev needs absolute helper path
          substituteInPlace $out/lib/udev/rules.d/52-digilent-usb.rules \
            --replace 'RUN+="dftdrvdtch' 'RUN+="'$out'/lib/udev/dftdrvdtch'

          runHook postInstall
        '';

        # autoPatchelf must resolve adept libs
        preFixup = ''
          addAutoPatchelfSearchPath "$out/lib/digilent/adept"
        '';

        meta = {
          description = "Digilent Adept Runtime — libraries, firmware and udev rules for Digilent devices";
          homepage = "https://digilent.com/reference/software/adept/start";
          license = lib.licenses.unfreeRedistributable;
          platforms = [ "x86_64-linux" ];
          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        };
      };

      # WaveForms GUI, dwfcmd CLI, libdwf SDK
      packages.digilent-waveforms = pkgs.stdenv.mkDerivation {
        pname = "digilent-waveforms";
        version = waveformsVersion;
        src = debSrc waveformsDeb;

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          binutils
          gzip
          zstd
          makeWrapper
          qt6.qtwayland
        ];
        buildInputs = with pkgs; [
          libusb1
          avahi
          openssl_3
          stdenv.cc.cc.lib
          self.packages.${system}.digilent-adept
          qt6.qtbase # Qt core modules
          qt6.qtmultimedia
          qt6.qtdeclarative # Qml
          qt6.qtserialport # libQt6SerialPort
        ];

        dontConfigure = true;
        dontBuild = true;
        dontWrapQtApps = true; # wrapped manually below

        unpackPhase = ''
          mkdir -p wf-deb && cd wf-deb
          ar x "$src"
          zstd -dc data.tar.zst | tar xf -
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin \
                   $out/lib \
                   $out/include/digilent/waveforms \
                   $out/share/digilent/waveforms \
                   $out/share/applications \
                   $out/share/mime/packages \
                   $out/share/man/man1

          # Binaries
          cp -f usr/bin/waveforms usr/bin/dwfcmd $out/bin/
          # libdwf SDK for dwfcmd and developers
          cp -fd usr/lib/libdwf.so* $out/lib/
          # Headers, samples, firmware, docs, pixmaps
          cp -r usr/include/digilent/waveforms/* $out/include/digilent/waveforms/
          cp -r usr/share/digilent/waveforms/* $out/share/digilent/waveforms/
          cp -f usr/share/man/man1/*.gz $out/share/man/man1/

          # Desktop entry with store paths
          sed -e "s|/usr/bin/waveforms|$out/bin/waveforms|g" \
              -e "s|/usr/share/digilent/waveforms/pixmaps/256.png|$out/share/digilent/waveforms/pixmaps/256.png|g" \
              usr/share/applications/digilent.waveforms.desktop \
            > $out/share/applications/digilent.waveforms.desktop
          cp -f usr/share/mime/packages/digilent.waveforms.xml $out/share/mime/packages/

          runHook postInstall
        '';

        # autoPatchelf must see adept libs too
        preFixup = ''
          addAutoPatchelfSearchPath "${self.packages.${system}.digilent-adept}/lib/digilent/adept"
        '';

        postFixup = ''
          # Unset crashing vars; set Qt paths
          qtPlugins="${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}:"
          qtPlugins+="${pkgs.qt6.qtwayland}/${pkgs.qt6.qtbase.qtPluginPrefix}:"
          qtPlugins+="${pkgs.qt6.qtmultimedia}/${pkgs.qt6.qtbase.qtPluginPrefix}"
          qtQml="${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}:"
          qtQml+="${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtQmlPrefix}"
          wrapProgram $out/bin/waveforms \
            --unset QT_PLUGIN_PATH \
            --unset QT_STYLE_OVERRIDE \
            --unset QT_QPA_PLATFORMTHEME \
            --set QT_PLUGIN_PATH "$qtPlugins" \
            --set QML_IMPORT_PATH "$qtQml" \
            --set QML2_IMPORT_PATH "$qtQml" \
            --set XLNX_DIGILENT_ADEPT_CONF "${
              self.packages.${system}.digilent-adept
            }/etc/digilent-adept.conf" \
            --set DIGILENT_DATA_DIR "${self.packages.${system}.digilent-adept}/share/digilent/adept/data"

          wrapProgram $out/bin/dwfcmd \
            --set XLNX_DIGILENT_ADEPT_CONF "${
              self.packages.${system}.digilent-adept
            }/etc/digilent-adept.conf" \
            --set DIGILENT_DATA_DIR "${self.packages.${system}.digilent-adept}/share/digilent/adept/data"
        '';

        meta = {
          description = "Digilent WaveForms — virtual bench instrument software (oscilloscope, waveform generator, logic analyzer, power supplies)";
          homepage = "https://digilent.com/reference/software/waveforms/waveforms-3/start";
          license = lib.licenses.unfreeRedistributable;
          platforms = [ "x86_64-linux" ];
          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
          mainProgram = "waveforms";
        };
      };
    };

  flake.nixosModules.digilent =
    { pkgs, lib, ... }:
    let
      digi = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # Unfree allowlist incl. requireFile deb names
      nixpkgs.config.allowUnfreePredicate = lib.mkDefault (
        pkg:
        let
          name = lib.getName pkg;
        in
        name == "digilent-adept"
        || name == "digilent-waveforms"
        || lib.hasPrefix "digilent.adept.runtime_" name
        || lib.hasPrefix "digilent.waveforms_" name
      );

      environment.systemPackages = [
        digi.digilent-waveforms
        digi.digilent-adept
      ];

      # udev rules for USB device access
      services.udev.packages = [ digi.digilent-adept ];
    };
}
