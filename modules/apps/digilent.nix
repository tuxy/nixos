# Digilent Adept Runtime + WaveForms for NixOS
#
# The official Digilent .deb packages are proprietary, so they are NOT kept in
# this git repo. The module reads them from ${debDir} (see below) at build
# time via a file:// fetch pinned to the hash from `nix-prefetch-url`.
#
# Just download the debs and drop them at the expected paths — if one is
# missing you'll get an error showing the required filename:
#   * Adept Runtime: https://digilent.com/reference/software/adept/start
#   * WaveForms:     https://digilent.com/reference/software/waveforms/waveforms-3/start
#
# Enable on a host by importing self.nixosModules.digilent.

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
      # perSystem pkgs don't inherit the host's `allowUnfree`, so build these
      # two packages with a pkgs that permits exactly them.
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          (lib.getName pkg) == "digilent-adept"
          || (lib.getName pkg) == "digilent-waveforms";
      };

      # ------------------------------------------------------------------
      # .deb sources (outside this repo on purpose)
      #
      # fetched with a file:// URL at eval time — pure-eval safe, and the
      # sha256 (from `nix-prefetch-url "file://$PWD/<file>.deb"`) pins the
      # exact bytes. A missing deb fails with an error showing the filename.
      # ------------------------------------------------------------------
      debDir = "/home/tuxy/Digilent";

      adeptVersion = "2.30.1";
      waveformsVersion = "3.25.1";

      debSrc =
        { filename, sha256, url }:
        pkgs.fetchurl {
          url = "file://${debDir}/${filename}";
          inherit sha256;
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
      # ------------------------------------------------------------------
      # Adept Runtime: shared libs, firmware, udev rules + dftdrvdtch helper
      # ------------------------------------------------------------------
      packages.digilent-adept = pkgs.stdenv.mkDerivation {
        pname = "digilent-adept";
        version = adeptVersion;
        src = debSrc adeptDeb;

        nativeBuildInputs = with pkgs; [ autoPatchelfHook binutils gzip zstd ];
        buildInputs = with pkgs; [ libusb1 avahi openssl_3 stdenv.cc.cc.lib ];

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

          # udev rules + the dftdrvdtch helper binary
          cp -f etc/udev/rules.d/52-digilent-usb.rules $out/lib/udev/rules.d/
          cp -f usr/lib/udev/dftdrvdtch $out/lib/udev/

          # Config file with Nix-store paths baked in
          sed \
            -e "s|^DigilentPath=.*|DigilentPath=$out/share/digilent|" \
            -e "s|^DigilentDataPath=.*|DigilentDataPath=$out/share/digilent/adept/data|" \
            etc/digilent-adept.conf > $out/etc/digilent-adept.conf

          # udev looks up bare program names only in a fixed set of dirs; point
          # it straight at the store copy of the helper instead (NixOS's udev
          # rule check requires absolute paths to exist).
          substituteInPlace $out/lib/udev/rules.d/52-digilent-usb.rules \
            --replace 'RUN+="dftdrvdtch' 'RUN+="'$out'/lib/udev/dftdrvdtch'

          runHook postInstall
        '';

        # Let autoPatchelfHook resolve the adept libs against each other.
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

      # ------------------------------------------------------------------
      # WaveForms: GUI app + dwfcmd CLI + libdwf SDK
      # ------------------------------------------------------------------
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
          qt6.qtbase # Widgets, Gui, Core, Network, SerialPort
          qt6.qtmultimedia
          qt6.qtdeclarative # Qml
          qt6.qtserialport # libQt6SerialPort
        ];

        dontConfigure = true;
        dontBuild = true;
        dontWrapQtApps = true; # we wrap manually with wrapProgram below

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
          # libdwf SDK (used by dwfcmd and by developers)
          cp -fd usr/lib/libdwf.so* $out/lib/
          # Headers + samples + firmware + docs + lang + pixmaps
          cp -r usr/include/digilent/waveforms/* $out/include/digilent/waveforms/
          cp -r usr/share/digilent/waveforms/* $out/share/digilent/waveforms/
          cp -f usr/share/man/man1/*.gz $out/share/man/man1/

          # Desktop entry with store paths (icon + executable)
          sed -e "s|/usr/bin/waveforms|$out/bin/waveforms|g" \
              -e "s|/usr/share/digilent/waveforms/pixmaps/256.png|$out/share/digilent/waveforms/pixmaps/256.png|g" \
              usr/share/applications/digilent.waveforms.desktop \
            > $out/share/applications/digilent.waveforms.desktop
          cp -f usr/share/mime/packages/digilent.waveforms.xml $out/share/mime/packages/

          runHook postInstall
        '';

        # autoPatchelfHook must also see the adept libs (they're in a subdir).
        preFixup = ''
          addAutoPatchelfSearchPath "${self.packages.${system}.digilent-adept}/lib/digilent/adept"
        '';

        postFixup = ''
          # Point the app at the adept firmware/config via env vars (no /etc
          # needed), and give Qt isolated plugin/QML paths. All qt6 modules
          # install under qtbase's shared qtPluginPrefix/qtQmlPrefix.
          #
          # IMPORTANT: the inherited system QT_PLUGIN_PATH (flatpak/profile Qt
          # plugins) and QT_STYLE_OVERRIDE crash this proprietary app, so we
          # unset them and set an isolated plugin path.
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
            --set XLNX_DIGILENT_ADEPT_CONF "${self.packages.${system}.digilent-adept}/etc/digilent-adept.conf" \
            --set DIGILENT_DATA_DIR "${self.packages.${system}.digilent-adept}/share/digilent/adept/data"

          wrapProgram $out/bin/dwfcmd \
            --set XLNX_DIGILENT_ADEPT_CONF "${self.packages.${system}.digilent-adept}/etc/digilent-adept.conf" \
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
      # Only these two packages are allowed to be unfree, regardless of the
      # host's global setting.
      nixpkgs.config.allowUnfreePredicate = lib.mkDefault (pkg:
        (lib.getName pkg) == "digilent-adept"
        || (lib.getName pkg) == "digilent-waveforms");

      environment.systemPackages = [
        digi.digilent-waveforms
        digi.digilent-adept
      ];

      # USB device access: MODE:=666 for Digilent/FTDI devices + the
      # dftdrvdtch helper (detaches the kernel ftdi_sio driver so the
      # userspace D2XX driver can claim the device).
      services.udev.packages = [ digi.digilent-adept ];
    };
}
