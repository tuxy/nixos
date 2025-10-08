{
  pkgs ?
    import <nixpkgs> {
      config.cudaSupport = true;
      config.allowUnfree = true;
    },
}:
pkgs.stdenv.mkDerivation {
  name = "cuda-env-shell";
  buildInputs = with pkgs; [
    cudatoolkit
    blender
  ];
  shellHook = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
