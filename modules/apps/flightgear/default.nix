# FlightGear nightly (development `next` branch) with the HDR pipeline.
#
# This follows https://wiki.flightgear.org/Building_FlightGear: SimGear and
# FlightGear are built from matching `next` branches, against the FlightGear
# fork of OpenSceneGraph. The three source snapshots plus fgdata are pinned so
# the build is reproducible; bump the `rev`s and hashes below for a newer
# nightly.
#
# The HDR compositor is already the default on `next` (fgdata's
# Compositor/default.xml includes HDR/hdr.xml), but the desktop entry and the
# `fgfs-hdr` launcher select `--compositor=Compositor/HDR/hdr` explicitly. HDR
# needs an OpenGL 4.1+ core-profile driver.
#
# Pins are from 2026-11-09 .. 2026-11-12. To update:
#
#   for r in flightgear simgear fgdata openscenegraph; do
#     git ls-remote https://gitlab.com/flightgear/$r.git refs/heads/next
#   done
#
# then prefetch each archive with
#
#   nix-prefetch-url --unpack \
#     "https://gitlab.com/flightgear/<repo>/-/archive/<rev>/<repo>-<rev>.tar.gz"
#
# and convert the result with
#
#   nix hash convert --hash-algo sha256 --to sri <hash>
{ self, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      flightgearRev = "aa7715473824723153d75885779d29b86671c5f8";
      simgearRev = "b34098f4feed9404a43d276faa89d9b043c3b356";
      fgdataRev = "4cb18123623d309a05019af0d3370e75ed38579f";
      openscenegraphRev = "9090931c7753db996744d5d94dc00c9928a1d509";

      flightgearSrc = pkgs.fetchFromGitLab {
        owner = "flightgear";
        repo = "flightgear";
        rev = flightgearRev;
        hash = "sha256-98oWPsX+6az3gRyWJ+nI0u5pl6bn78KfgYqj59voPsc=";
      };

      simgearSrc = pkgs.fetchFromGitLab {
        owner = "flightgear";
        repo = "simgear";
        rev = simgearRev;
        hash = "sha256-1F6uHJaskzRnjYQnmZgfJoR+21GwqUpQBPYn1+yWfVI=";
      };

      # fgdata is the base package (aircraft, scenery, HDR compositor, Nasal
      # modules). It is large, but FlightGear needs a matching next tree.
      fgdataSrc = pkgs.fetchFromGitLab {
        owner = "flightgear";
        repo = "fgdata";
        rev = fgdataRev;
        hash = "sha256-lt6J9kH5cwcXUSDFqmMr3bR7TDO/4lZHBvtHkSFPSwE=";
      };

      openscenegraphSrc = pkgs.fetchFromGitLab {
        owner = "flightgear";
        repo = "openscenegraph";
        rev = openscenegraphRev;
        hash = "sha256-uWU7XcZTbgJNvw3rfTi7SX0cPlS/XwkFgRfSWykak8E=";
      };

      cpp-httplib = pkgs.fetchFromGitHub {
        owner = "yhirose";
        repo = "cpp-httplib";
        tag = "v0.54.1";
        hash = "sha256-VksZtcb2K2Ne/tGFnHdV6j5MT6UfTDLmYxcjqCEKMUA=";
      };

      openscenegraph = pkgs.stdenv.mkDerivation {
        pname = "openscenegraph-flightgear";
        version = "3.6.5-nightly-2026-11-01";

        src = openscenegraphSrc;

        nativeBuildInputs = with pkgs; [
          pkg-config
          cmake
          doxygen
        ];

        buildInputs = with pkgs; [
          glib
          libxml2
          zlib
          libjpeg
          giflib
          libtiff
          libpng
          curl
          freetype
          boost
          libx11
          libxinerama
          libxrandr
          libGLU
          libGL
        ];

        patches = [
          (pkgs.fetchpatch {
            name = "opencascade-api-patch";
            url = "https://github.com/openscenegraph/OpenSceneGraph/commit/bc2daf9b3239c42d7e51ecd7947d31a92a7dc82b.patch";
            hash = "sha256-VR8YKOV/YihB5eEGZOGaIfJNrig1EPS/PJmpKsK284c=";
          })
          # Fix compiling with libtiff when libtiff is compiled using CMake
          (pkgs.fetchurl {
            url = "https://github.com/openscenegraph/OpenSceneGraph/commit/9da8d428f6666427c167b951b03edd21708e1f43.patch";
            hash = "sha256-YGG/DIHU1f6StbeerZoZrNDm348wYB3ydmVIIGTM7fU=";
          })
        ];

        meta = {
          description = "3D graphics toolkit (FlightGear fork, nightly)";
          homepage = "https://gitlab.com/flightgear/openscenegraph";
          license = with lib.licenses; [
            lgpl21Only
            wxWindowsException31
          ];
          platforms = lib.platforms.linux;
        };
      };

      simgear = pkgs.stdenv.mkDerivation {
        pname = "simgear";
        version = "2024.2.0-nightly-2026-11-12";

        src = simgearSrc;
        patches = [
          ./simgear-canvas-map.patch
          # Nasal: reclaim empty GC blocks and make the collection budget
          # configurable, so a transient no longer slows every later collection.
          ./simgear-nasal-gc.patch
          # Persist linked GLSL programs per (driver, shader-source) key.
          ./simgear-shader-cache.patch
          # Cache scheme -> Technique in Effect::chooseTechnique.
          ./simgear-technique-cache.patch
          # FG_SUBSYS_TIMING=1: per-subsystem update cost attribution.
          # subsys timing + bounded FDM catch-up (same file, one patch).
          ./simgear-subsys-timing.patch
          # FG_EVENT_TIMING=1: per-timer cost dump (sub-ms aware).
          ./simgear-event-timing.patch
        ];

        nativeBuildInputs = with pkgs; [
          cmake
          pkg-config
        ];

        buildInputs = with pkgs; [
          plib
          boost
          libjpeg
          freealut
          expat
          apr
          libglut
          xorgproto
          libx11
          libxext
          libxi
          libice
          libsm
          libxt
          libxmu
          libGLU
          libGL
        ];

        # SimGearConfig.cmake does find_dependency() on these, so consumers
        # (FlightGear) need them on CMAKE_PREFIX_PATH. Pango/HarfBuzz/Freetype
        # are the new text stack; the rest are linked into the static library.
        propagatedBuildInputs = with pkgs; [
          zlib
          xz
          curl
          freetype
          c-ares
          openal
          pango
          harfbuzz
          openscenegraph
        ];

        # SimGear's test suite FetchContent's cpp-httplib; keep configure
        # offline and skip the test binaries.
        cmakeFlags = [
          (lib.cmakeBool "ENABLE_TESTS" false)
        ];

        meta = {
          description = "Simulation construction toolkit (nightly)";
          homepage = "https://wiki.flightgear.org/SimGear";
          license = lib.licenses.lgpl2;
          platforms = lib.platforms.linux;
        };
      };

      flightgear = pkgs.stdenv.mkDerivation {
        pname = "flightgear";
        version = "2024.2.0-nightly-2026-11-09";

        src = flightgearSrc;

        nativeBuildInputs = with pkgs; [
          cmake
          pkg-config
          makeWrapper
          qt5.wrapQtAppsHook
        ];

        buildInputs = with pkgs; [
          simgear
          openscenegraph
          freealut
          libjpeg
          openal
          plib
          zlib
          boost
          libpng
          fltk_1_3
          apr
          qt5.qtbase
          qt5.qtquickcontrols2
          qt5.qtdeclarative
          qt5.qtsvg
          qt5.qttools
          glew
          curl
          xz
          nlohmann_json
          fmt
          fontconfig
          expat
          libglut
          libGLU
          libGL
          libice
          libsm
          libunwind
          libx11
          xorgproto
          libxext
          libxi
          libxmu
          libxt
          udev
        ];

        cmakeFlags = [
          # Use the packaged fmt instead of FetchContent from GitHub.
          (lib.cmakeBool "SYSTEM_FMTLIB" true)
          # Supplied as a local source tree by the FetchContent override below.
          "-DFETCHCONTENT_SOURCE_DIR_HTTPLIB=${cpp-httplib}"
          # No need to compile the test suite (and its bundled cppunit).
          (lib.cmakeBool "BUILD_TESTING" false)
          (lib.cmakeBool "ENABLE_SENTRY" false)
          # Build the launcher's translations from the matching fgdata tree.
          "-DFG_DATA_DIR=${fgdata}/share/FlightGear"
        ];

        qtWrapperArgs = [
          "--set"
          "FG_ROOT"
          "${fgdata}/share/FlightGear"
        ];

        # Make the stock desktop entry ask for HDR explicitly, and label the
        # menu entry so it is distinguishable from a stable FlightGear.
        postPatch = ''
          substituteInPlace package/org.flightgear.FlightGear.desktop.in \
            --replace-fail \
              'Exec=fgfs @DESKTOP_FILE_RUN_ARGS@' \
              'Exec=fgfs @DESKTOP_FILE_RUN_ARGS@ --compositor=Compositor/HDR/hdr' \
            --replace-fail \
              'Name=FlightGear' \
              'Name=FlightGear Nightly'
        '';

        postInstall = ''
          # Handy terminal launcher that does not depend on fgdata's default
          # compositor staying HDR.
          makeWrapper $out/bin/fgfs $out/bin/fgfs-hdr \
            --add-flags "--compositor=Compositor/HDR/hdr"

          # Remove redundant AppImage artifacts.
          rm -rf "$out/appdir"
        '';

        meta = {
          description = "Free and highly sophisticated flight simulator (nightly, HDR)";
          homepage = "https://www.flightgear.org/";
          license = lib.licenses.gpl2Plus;
          platforms = lib.platforms.linux;
          mainProgram = "fgfs";
        };

        passthru = {
          data = fgdata;
        };
      };

      # Local performance build: the single-thread/phase-instrumentation patch
      # first (flightgear-perf.patch is generated on top of it), then the
      # incremental-paged-compile + hitch instrumentation.
      flightgearPatched = flightgear.overrideAttrs (old: {
        pname = "flightgear-nightly-patched";
        patches = (old.patches or [ ]) ++ [
          ./flightgear-single-thread.patch
          ./flightgear-perf.patch
          # Per-callback Nasal timer cost attribution (FG_NASAL_CB_TIMING=1).
          ./flightgear-nasal-timing.patch
          # Tile LOD refresh: skip unchanged visibility + round-robin over tiles.
          ./flightgear-scenery-lod.patch
          # Screenshot via OSG capture handler, swap-timing probe, tile split
          # timing, barrier knobs. Instrumentation only; all env-gated.
          ./flightgear-instrumentation.patch
        ];
      });

      fgdata = pkgs.stdenv.mkDerivation {
        pname = "flightgear-data";
        version = "2024.2.0-nightly-2026-11-12";

        src = fgdataSrc;

        dontUnpack = true;

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/share/FlightGear"
          cp -a "$src"/. "$out/share/FlightGear/"

          # HDR shadow atlas 8192 -> 4096: 134 MB -> 33 MB of depth16 with no
          # visible change at these cascade extents (0.5 mm to 85 mm per texel).
          chmod -R u+w "$out/share/FlightGear"
          # GTAO at half resolution: 18.3 ms -> ~3 ms at 1080p, denoised anyway.
          (cd "$out/share/FlightGear" && patch -p1 < ${./fgdata-ao-half-res.patch})
          # Sun-dependent atmosphere LUTs at ~8 Hz instead of every frame (~7-11 ms at 1080p).
          (cd "$out/share/FlightGear" && patch -p1 < ${./fgdata-atmos-lut-throttle.patch})
          # GPU property batch: clouds .25, FXAA, SSS 8 (no buffer-scale property).
          (cd "$out/share/FlightGear" && patch -p1 < ${./fgdata-gpu-property-batch.patch})
          # Histogram metering denominator + exposure hold: fixes white screen at
          # any hdr/render-scale < 1 (the denominator came from the window size).
          (cd "$out/share/FlightGear" && patch -p1 < ${./fgdata-histogram-denominator.patch})
          # Non-PBR model path: accept the emissive_factor uniform so property-
          # driven lighting (SGPBRAnimation) works under HDR.

          runHook postInstall
        '';

        meta = {
          description = "FlightGear base package (nightly)";
          homepage = "https://www.flightgear.org/";
          license = lib.licenses.gpl2Plus;
          platforms = lib.platforms.linux;
        };
      };
    in
    {
      packages.flightgear-nightly = flightgear;
      packages.flightgear-nightly-patched = flightgearPatched;
      packages.flightgear-nightly-data = fgdata;
      packages.flightgear-nightly-simgear = simgear;
      packages.flightgear-nightly-openscenegraph = openscenegraph;
    };

  flake.nixosModules.flightgear = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.flightgear-nightly
    ];
  };

  # Deckputer uses the local single-thread/phase-instrumented/Canvas-patched
  # build rather than the plain nightly package.
  flake.nixosModules.flightgear-patched = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.flightgear-nightly-patched
    ];
  };
}
