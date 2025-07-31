{}: {
  services.tailscale = {
    enable = true;
    authKeyFile = "../secrets/tailscale_key";
  };
}
