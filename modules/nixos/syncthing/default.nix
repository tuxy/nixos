{ ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/tuxy/syncthing";
    user = "tuxy";
  };
}
