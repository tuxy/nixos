check:
	nix flake check

install HOSTNAME DEVICE:
	read -p "Are you sure you want to install? (y/n) " -n 1 -r
	echo    # move to a new line
	[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

	sudo -v
	sed 's/HOSTNAME/{{HOSTNAME}}/g' ./modules/disko-template.nix > ./modules/hosts/{{HOSTNAME}}/disko.nix 
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{HOSTNAME}}
	sudo nixos-generate-config --show-hardware-config --no-filesystems --root /mnt > ./modules/hosts/{{HOSTNAME}}/hardware-configuration.nix
	sudo nix --experimental-features "nix-command flakes" flake lock
	sudo nixos-install --root /mnt --flake '.#{{HOSTNAME}}'

rebuild HOSTNAME:
	sudo -v
	sudo nixos-rebuild switch --flake .#{{HOSTNAME}}

update HOSTNAME:
	sudo -v
	nix flake update
	nix flake lock
	sudo nixos-rebuild switch --flake .#{{HOSTNAME}}
