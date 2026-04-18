{ self, ... }:
let
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
in
{
  flake.profiles.tuxy = tuxy;
}
