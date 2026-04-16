{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.user = { pkgs, ... }: {
    users = {
      mutableUsers = false;
      users.${profile.name} = {
        initialPassword = "1234";
        isNormalUser = true;
        description = profile.fullName;
        extraGroups = profile.groups;
        shell = pkgs.fish;
      };
    };

    nix.settings.trusted-users = [
      profile.name
    ];
  };
}
