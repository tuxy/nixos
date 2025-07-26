{
  description = "tuxy's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    disko,
    ...
  }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	  # Main configuration
          ./nixos/configuration.nix

	  # Home-manager configuration
          ./home-manager/home.nix
          home-manager.nixosModules.home-manager
          { home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ]; }
	  # Disk partitioning
          disko.nixosModules.disko
        ];
      };
    };
  };
}
