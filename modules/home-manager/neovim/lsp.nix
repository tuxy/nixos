{...}: {
  # Enable lsp and lsp-format in nixvim
  plugins = {
    # Enabling lsp's for neovim
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
	clangd.enable = true;
        nil_ls.enable = true;
        pylyzer.enable = true;
      };
    };
    lsp-format.enable = true;
  };
}
