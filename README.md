# Installation
Minimal image could work, but the graphical image's networking seems to be more stable (wireless)

### Partition with disko & generate config

Clone the repo:
`sudo git clone https://github.com/tuxy/nixos`

Use disko to create & mount:
`sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./nixos/modules/nixos/disko/default.nix`

Generate nix config without partitioning:
`sudo nixos-generate-config --no-filesystems --root /mnt`

- Either copy the config, or clone it again to `/mnt/etc/nixos`.

### Lock & Installation
Lock flake:
`sudo nix --experimental-features "nix-command flakes" flake lock`

Install:
`sudo nixos-install --root /mnt --flake '/mnt/etc/nixos#HOSTNAME'`
