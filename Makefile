test-configuration:
	nixos-rebuild test -I nixos-config=./configuration.nix

clean:
	rm -r result/ && rm nixos.qcow2
