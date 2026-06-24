{
  plugins.lsp.servers.taplo = {
    enable = true;

    rootMarkers = [ ".git" ];
  };

  plugins.conform-nvim.settings.formatters_by_ft.toml = [ "taplo" ];
}
