# NixOS Configuration

Flake-based NixOS configuration using [flake-parts](https://flake-parts.com), [import-tree](https://github.com/vic/import-tree), and [just](https://github.com/casey/just). Customized version of vimjoyer's dendritic niri config.

## Prerequisites

- Nix with flakes enabled
- [just](https://github.com/casey/just) task runner

```sh
nix shell nixpkgs#just
```

## Installation

Boot from a NixOS live image (graphical recommended for better wireless support).

### 1. Clone the repo

```sh
git clone https://github.com/tuxy/nixos
cd nixos
```

### 2. Initialize a new host (optional)

This creates the host config files from templates under `modules/hosts/<HOSTNAME>/`:

```sh
just init HOSTNAME
```

Customize the generated files (see [templates/README.md](templates/README.md) for details), then add them:

```sh
git add modules/hosts/HOSTNAME/
```

### 3. Partition and install

This partitions the disk with disko (LUKS + Btrfs), installs NixOS, and copies the repo to `/mnt/etc/nixconf`:

```sh
just install HOSTNAME DEVICE
```

Example:

```sh
just install deskputer /dev/nvme0n1
```

## Updating

Rebuild the current system:

```sh
just rebuild .
just rebuild .#deskputer
```

Update all flake inputs, lock, and rebuild:

```sh
just update .
```

## Bootable Media

Build a live ISO from the `live-iso` host config:

```sh
just create-media
```

## Project Structure

```
.
├── flake.nix                  # Flake entry point (delegates to flake-parts + import-tree)
├── justfile                   # Task runner recipes
├── modules/
│   ├── parts.nix              # flake-parts system config (x86_64-linux)
│   ├── profile.nix            # User profile (tuxy)
│   ├── features/              # Feature modules
│   │   ├── desktop/           # Niri WM, Noctalia shell, Stylix theming
│   │   ├── system/            # Laptop, NVIDIA, printing, nix-ld
│   │   └── ...                # Firefox, gaming, neovim, shell, etc.
│   └── hosts/                 # Per-host configurations
│       ├── deskputer/         # Desktop host
│       └── live-iso/          # Bootable rescue ISO
├── templates/                 # Scaffolding for new hosts
└── secrets/                   # (placeholder)
```

Each `.nix` file under `modules/` is auto-discovered by `import-tree` and registers its own flake outputs. Feature modules are composed by importing them in a host's `configuration.nix`.
