{
  config,
  pkgs,
  ...
}: {
  # Installing lsp s
  home.packages = with pkgs; [
    rust-analyzer
    pylyzer 
    nil
    ccls
  ];

  # Enable lsp and lsp-format in nixvim
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        rust_analyzer = {
          enable = true;
	  installCargo = true;
	  installRustc = true;
	  installRustfmt = true;
	};
        ccls.enable = true;
        nil_ls.enable = true;
        pylyzer.enable = true;
      };
    };
    lsp-format.enable = true;
  };
}
