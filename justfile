has-nom := `command -v nom >/dev/null 2>&1 && echo true || echo false`
nom-flag := if has-nom == "true" { "--log-format internal-json -v |& nom --json" } else { "" }

check:
    nix flake check

rebuild TARGET:
    sudo -v
    sudo nixos-rebuild switch --flake {{ TARGET }}

update TARGET:
    sudo -v
    nix flake update 
    nix flake lock
    sudo nixos-rebuild switch --flake {{ TARGET }}

[confirm]
hard-clean:
    sudo -v
    nix-collect-garbage --delete-old
    sudo nix-collect-garbage --delete-old
    nix-store --optimise
    sudo nix-store --optimise

clean:
    nix-collect-garbage --delete-older-than 7d
    nix-store --optimise

# Includes optional --encrypt flag to utilise interactive input for LUKS disk encryption
[arg('encrypt-flag', pattern='--encrypt|--no-encrypt')]
[confirm("Are you sure you want to install (y/n)?")]
install HOSTNAME DEVICE encrypt-flag="--no-encrypt":
    sudo -v
    if [ "{{ encrypt-flag }}" = "--encrypt" ]; then \
            sed -e 's#HOSTNAME#{{ HOSTNAME }}#g' -e 's#DISK#{{ DEVICE }}#g' templates/disko-luks.nix > modules/hosts/{{ HOSTNAME }}/disko.nix; \
    else \
            sed -e 's#HOSTNAME#{{ HOSTNAME }}#g' -e 's#DISK#{{ DEVICE }}#g' templates/disko/disko-default.nix > modules/hosts/{{ HOSTNAME }}/disko.nix; \
    fi
    git add ./modules/hosts/{{ HOSTNAME }}/disko.nix
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{ HOSTNAME }}
    sudo nixos-generate-config --show-hardware-config --no-filesystems --root /mnt > modules/hosts/{{ HOSTNAME }}/_hardware-configuration.nix
    sudo nix --experimental-features "nix-command flakes" flake lock
    sudo nixos-install --root /mnt --flake '.#{{ HOSTNAME }}'
    sudo cp -r . /mnt/etc/nixconf

[confirm("Do you want to create a bootable iso? (y/n)")]
create-media:
    sudo -v
    sudo nix build .#nixosConfigurations.live-iso.config.system.build.isoImage {{ nom-flag }}

[confirm("Are you sure you want to initialise a new config using the current system's nixos-generate? This will overwrite the old files. (y/n)")]
init HOSTNAME:
    mkdir -p modules/hosts/{{ HOSTNAME }}
    sed -e "s#HOSTNAME#{{ HOSTNAME }}#g" templates/default.nix > modules/hosts/{{ HOSTNAME }}/default.nix
    sed -e "s#HOSTNAME#{{ HOSTNAME }}#g" templates/hardware.nix > modules/hosts/{{ HOSTNAME }}/hardware.nix
    sed -e "s#HOSTNAME#{{ HOSTNAME }}#g" templates/configuration.nix > modules/hosts/{{ HOSTNAME }}/configuration.nix
    git add modules/hosts/{{ HOSTNAME }}/default.nix
    git add modules/hosts/{{ HOSTNAME }}/hardware.nix
    git add modules/hosts/{{ HOSTNAME }}/configuration.nix
