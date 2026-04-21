# Creating a New Host

Templates are used by `just init HOSTNAME` to scaffold host config files under `modules/hosts/<HOSTNAME>/`.

## Quick Start

```sh
just init myhost
```

This substitutes `HOSTNAME` in each template and writes:

| Template | Output |
|---|---|
| `default.nix` | `modules/hosts/myhost/default.nix` |
| `configuration.nix` | `modules/hosts/myhost/configuration.nix` |
| `hardware-configuration.nix` | `modules/hosts/myhost/hardware-configuration.nix` |

No need to stage git changes, `git add -A` is called automatically.

## Template Files

### `default.nix`

Defines `flake.nixosConfigurations.HOSTNAME` — the top-level nixosSystem entry. Imports the host's configuration module.

### `configuration.nix`

Defines `flake.nixosModules.HOSTNAMEConfiguration` — the main host module. By default it imports:

- **lanzaboote** — Secure Boot support
- **disko** — Declarative disk partitioning
- **HOSTNAMEDisko** — The disk layout
- **HOSTNAMEHardware** — Hardware scan module

Base settings include: NetworkManager, Bluetooth, fwupd, DNS (1.1.1.1/8.8.8.8), and `stateVersion = "25.11"`.

### `hardware-configuration.nix`

Defines `flake.nixosModules.HOSTNAMEHardware` — hardware detection defaults (Intel CPU, DHCP, `x86_64-linux`). Should work out of the box for Intel CPUs. Not too sure about AMD.

### `disko-template.nix`

Not copied by `just init` — used directly by `just install` which renders it with the given hostname and device path. See disk layout below.

## Disk Layout

The `disko-template.nix` creates:

| Partition | Size | Filesystem | Mount |
|---|---|---|---|
| ESP | 512M | vfat | `/boot` |
| LUKS | 100% of disk | Btrfs | — |

Btrfs subvolumes inside the LUKS container:

| Subvolume | Mount | Options |
|---|---|---|
| `root` | `/` | compress=zstd, noatime |
| `home` | `/home` | compress=zstd, noatime |
| `nix` | `/nix` | compress=zstd, noatime |
| `log` | `/var/log` | compress=zstd, noatime |
| `swap` | `/swap` | 10G swapfile |

## Customization

After running `just init`, edit `modules/hosts/myhost/configuration.nix` to add feature modules:

```nix
imports = [
  inputs.lanzaboote.nixosModules.lanzaboote
  inputs.disko.nixosModules.disko
  self.diskoConfigurations.myhost
  self.nixosModules.myhostHardware

  # Add features:
  self.nixosModules.packages-all
  self.nixosModules.desktop
  self.nixosModules.shell
  self.nixosModules.user
  # etc.
];
```

Available feature modules are in `modules/features/`. Each `.nix` file registers a `flake.nixosModules.*` entry via `import-tree`. 
No need to modify `flake.nix`, all configurations are automatically imported.

## Full Install Workflow

```sh
just init myhost
# Edit modules/hosts/myhost/configuration.nix to add features
git add modules/hosts/myhost/
just install myhost /dev/nvme0n1
```

Boot into new system, and if lanzaboote is set up and computer in setup mode, then secure boot keys should be automatically enrolled.
