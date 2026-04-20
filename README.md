# Installation
Minimal image could work, but the graphical image's networking seems to be more stable (wireless)

### Partition with disko+luks & install

Clone the repo and get just:
`git clone https://github.com/tuxy/nixos; nix-shell -p just`

Install:
`just install HOSTNAME DEVICE` e.g. `just install deskputer /dev/nvme0n1`

### Updates & Rebuilds

To rebuild:

`just rebuild .` or `just rebuild .#deskputer`

To update the flake and lock it:

`just update`

