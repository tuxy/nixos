{ pkgs, ... }: {
  home.packages = with pkgs; [ vscodium ]; 

  programs.vscode = {
    enable = true; 
    package = pkgs.vscodium; # Open-source vscode
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      rust-lang.rust-analyzer
      wakatime.vscode-wakatime
      vscodevim.vim
      ms-vscode.cpptools
    ];
  };
}
