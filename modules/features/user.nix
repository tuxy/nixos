{ self, ... }:
let
  profile = self.profiles.tuxy;
in
{
  flake.nixosModules.user =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = false;
        users.${profile.name} = {
          hashedPassword = "$y$j9T$SDxwxoQ5x8cyHR6177xVq0$HFxpQoVJZ6ojBtWFpwYCXofDV3O.rZ7ztjzpH.cz4h8";
          isNormalUser = true;
          description = profile.fullName;
          extraGroups = profile.groups;
          shell = pkgs.bash;
        };
      };

      nix.settings.trusted-users = [
        profile.name
      ];
    };
}
