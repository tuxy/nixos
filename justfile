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
	sed -e 's#HOSTNAME#{{HOSTNAME}}#g' -e 's#DISK#{{DEVICE}}#g' templates/disko-template.nix > modules/hosts/{{HOSTNAME}}/disko.nix 
	git add ./modules/hosts/{{HOSTNAME}}/disko.nix
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{HOSTNAME}}
	sudo nix --experimental-features "nix-command flakes" flake lock
	sudo nixos-install --root /mnt --flake '.#{{HOSTNAME}}'
	sudo cp -r . /mnt/etc/nixconf

[confirm("Are you sure you want to secure this device? Make sure you are in setup mode (y/n)")]
secure HOSTNAME:
	sudo -v
	sudo sbctl create-keys
	sudo sbctl enroll-keys --microsoft --firmware-builtin
	sed -i 's#secureBoot.enable = false;#secureBoot.enable = true;#g' modules/hosts/{{HOSTNAME}}/configuration.nix
	sudo nixos-rebuild boot --flake .#{{HOSTNAME}}

[confirm("Do you want to create a bootable iso? (y/n)")]
create-media:
	sudo -v
	sudo nix build .#nixosConfigurations.live-iso.config.system.build.isoImage

[confirm("Are you sure you want to initialise a new config? This will overwrite the old files. (y/n)")]
init HOSTNAME:
        sed -e "s#HOSTNAME#{{HOSTNAME}}#g" default.nix > modules/hosts/{{HOSTNAME}}/default.nix
        sed -e "s#HOSTNAME#{{HOSTNAME}}#g" hardware-configuration.nix > modules/hosts/{{HOSTNAME}}/hardware-configuration.nix
        sed -e "s#HOSTNAME#{{HOSTNAME}}#g" configuration.nix > modules/hosts/{{HOSTNAME}}/configuration.nix
