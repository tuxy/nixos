check:
	nix flake check

install HOSTNAME DEVICE:
	sudo -v
	sed -e 's#HOSTNAME#{{HOSTNAME}}#g' -e 's#DISK#{{DEVICE}}#g' ./disko-template.nix > ./modules/hosts/{{HOSTNAME}}/disko.nix 
	git add ./modules/hosts/{{HOSTNAME}}/disko.nix
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{HOSTNAME}}
	sudo nix --experimental-features "nix-command flakes" flake lock
	sudo nixos-install --root /mnt --flake '.#{{HOSTNAME}}'

rebuild TARGET:
	sudo -v
	sudo nixos-rebuild switch --flake {{TARGET}}

update HOSTNAME:
	sudo -v
	nix flake update
	nix flake lock
	sudo nixos-rebuild switch --flake .#{{HOSTNAME}}
