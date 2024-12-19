{
  description = "Home flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nix-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let 
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nix-config = lib.nixosSystem {
        system = "x86_64-linux";
	modules = [ ./configuration.nix ];
      };
    };
  };
}
