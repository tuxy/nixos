# Installation
Minimal image could work, but the graphical image's networking seems to be more stable (wireless)

### Partition with disko & generate config

Use disko to create & mount:
`sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko-config.nix`

Clone the repo to `/mnt/etc/nixos`:
`sudo git clone https://github.com/tuxy/nixos`

Generate nix config without partitioning:
`sudo nixos-generate-config --no-filesystems --root /mnt`

### Lock & Installation
Lock flake:
`sudo nix --experimental-features "nix-command flakes" flake lock`

Install:
`sudo nixos-install --root /mnt --flake '/mnt/etc/nixos#nixos'`

### Home-manager
Run home-manager:
`home-manager switch --flake .`

