{ ... }: {
  flake.nixosModules.udev = { pkgs, ... }: {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"

      # https://get.vial.today/manual/linux-udev.html
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
