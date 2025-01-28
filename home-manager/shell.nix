{...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo -v && cd /etc/nixos && sudo git pull && sudo nixos-rebuild switch && cd -";
    };
    sessionVariables = {
      SSH_ASKPASS = ""; # Empty string for no askpass program
    };
  };
  programs.git = {
    enable = true;
    userName = "tuxy";
    userEmail = "lastpass7565@gmail.com"; # Git information
    extraConfig = {
      credential.helper = "store"; # Store git credentials
    };
  };
}
