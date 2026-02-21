# taken from https://git.sr.ht/~hervyqa/swayhome - top tier :)
{}: let
  name = "tuxy";
  fullName = "Binh Nguyen";
  hostname = "laputer"; # Change for computers
  email = "lastpass7565@gmail.com";
  timeZone = "Australia/Victoria";
  defaultLocale = "en_US.UTF-8";
  layout = "us";
in {
  inherit name;
  inherit fullName;
  inherit hostname;
  inherit email;
  inherit timeZone;
  inherit defaultLocale;
  inherit layout;
}
