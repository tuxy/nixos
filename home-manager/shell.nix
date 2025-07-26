{...}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake $HOME/nixos#$(hostname)";
    };
    sessionVariables = {
      SSH_ASKPASS = ""; # Empty string for no askpass program
    };
  };
  programs.git = {
    enable = true;
    userName = "Binh Nguyen";
    userEmail = "lastpass7565@gmail.com"; # Git information
    extraConfig = {
      credential.helper = "store"; # Store git credentials
    };
  };
}
