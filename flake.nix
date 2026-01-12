{
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
    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    jovian = {
      url = "github:jovian-experiments/jovian-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    copyparty.url = "github:9001/copyparty";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    agenix.url = "github:ryantm/agenix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      nix-flatpak,
      copyparty,
      firefox-addons,
      nix-on-droid,
      lsfg-vk-flake,
      jovian,
      disko,
      agenix,
      nixos-wsl,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        laputer = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            # Main configuration
            ./hosts/laputer/configuration.nix

            # lsfg-vk-flake
            lsfg-vk-flake.nixosModules.default

            # Home-manager configuration
            ./hosts/laputer/home.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                # Section for nixvim
                nixvim.homeModules.nixvim
              ];
              home-manager.users."tuxy".imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }

            # Disk partitioning
            disko.nixosModules.disko
          ];
        };
        deskputer = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            # Main configuration
            ./hosts/deskputer/configuration.nix

            # lsfg-vk-flake
            lsfg-vk-flake.nixosModules.default
            catppuccin.nixosModules.catppuccin

            # Home-manager configuration
            ./hosts/deskputer/home.nix
            home-manager.nixosModules.home-manager
            jovian.nixosModules.default
            {
              home-manager.sharedModules = [
                # Section for nixvim
                nixvim.homeModules.nixvim
              ];
              home-manager.users."tuxy".imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                catppuccin.homeModules.catppuccin
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
            }

            # Disk partitioning
            disko.nixosModules.disko
          ];
        };

        serverputer = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/serverputer/configuration.nix
            disko.nixosModules.disko

            # copyparty
            copyparty.nixosModules.default
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ copyparty.overlays.default ];
                imports = [ ./hosts/serverputer/file.nix ];
              }
            )
          ];
        };
        windowsputer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/windowsputer/configuration.nix

            ./hosts/windowsputer/home.nix
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            {
              home-manager.sharedModules = [
                # Section for nixvim
                nixvim.homeModules.nixvim
              ];
              home-manager.users."tuxy".imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
              home-manager.extraSpecialArgs = { inherit inputs; };
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
      };
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [
          ./hosts/phoneputer
          {
            home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ];
          }
        ];
      };
    };
}
