check:
	nix flake check

rebuild TARGET:
	sudo -v
	sudo nixos-rebuild switch --flake {{TARGET}}

update TARGET:
	sudo -v
	nix flake update
	nix flake lock
	sudo nixos-rebuild switch --flake {{TARGET}}

[confirm("Are you sure you want to install (y/n)?")]
install HOSTNAME DEVICE:
	sudo -v
	sed -e 's#HOSTNAME#{{HOSTNAME}}#g' -e 's#DISK#{{DEVICE}}#g' disko-template.nix > modules/hosts/{{HOSTNAME}}/disko.nix 
	git add ./modules/hosts/{{HOSTNAME}}/disko.nix
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{HOSTNAME}}
	sudo nix --experimental-features "nix-command flakes" flake lock
	sudo nixos-install --root /mnt --flake '.#{{HOSTNAME}}'
	sudo rm -rf /mnt/etc/nixos
	sudo cp -r . /mnt/etc/nixos

[confirm("Are you sure you want to secure this device? Make sure you are in setup mode (y/n)")]
secure HOSTNAME:
	sudo -v
	sudo sbctl create-keys
	sudo sbctl enroll-keys --microsoft --firmware-builtin
	sed -i 's#secureBoot.enable = false;#secureBoot.enable = true;#g' modules/hosts/{{HOSTNAME}}/configuration.nix
	sudo nixos-rebuild boot --flake .#{{HOSTNAME}}
