{ pkgs, ... }:

{
  dependencies.go.enable = false;

  extraPackages = with pkgs; [
    golangci-lint
    gotools
    gofumpt
    govulncheck
  ];

  plugins.lsp.servers.gopls = {
    enable = true;
  };

  plugins.lsp.servers.golangci_lint_ls = {
    enable = true;

    rootMarkers = [ "go.mod" ];
  };

  plugins.conform-nvim.settings.formatters_by_ft.go = [
    "goimports"
    "gofumpt"
    "golangci-lint"
  ];
}
