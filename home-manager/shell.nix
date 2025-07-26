{...}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "$HOME/nixos/scripts/rebuild";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
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
