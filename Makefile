test-configuration:
	nixos-rebuild build-vm -I nixos-config=./configuration.nix

clean:
	rm -r result/ && rm nixos.qcow2
