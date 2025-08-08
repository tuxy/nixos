{pkgs, ...}: {
  environment.systemPackages = [pkgs.copyparty];
  services.copyparty = {
    enable = true;
  };
}
