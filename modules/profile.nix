# taken from https://git.sr.ht/~hervyqa/swayhome - top tier :)
{self, ...}: {
  flake.nixosModules.profile = {}: let
    tuxy = {
      name = "tuxy";
      fullName = "Binh Nguyen";
      groups = [
        "networkmanager"
        "wheel"
        "syncthing"
        "libvirtd"
      ];
      email = "lastpass7565@gmail.com";
      timeZone = "Australia/Victoria";
      defaultLocale = "en_US.UTF-8";
      layout = "us";
    };
  in {
    inherit tuxy;
  };
}
