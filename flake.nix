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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      firefox-addons,
      disko,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            # Main configuration
            ./nixos/configuration.nix

            # Home-manager configuration
            ./home-manager/home.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                # Section for nixvim
                nixvim.homeManagerModules.nixvim
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }

            # Disk partitioning
            disko.nixosModules.disko
          ];
        };
      };
    };
}
