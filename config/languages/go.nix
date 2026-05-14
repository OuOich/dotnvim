{ pkgs, ... }:

{
  dependencies.go = {
    enable = true;
  };

  extraPackages = with pkgs; [
    gofumpt
    golangci-lint
    gotools
    govulncheck
  ];

  plugins.lsp.servers.gopls = {
    enable = true;

    settings = {
      gopls = {
        analyses = {
          fieldalignment = true;
          nilness = true;
          shadow = true;
          unusedparams = true;
          unusedwrite = true;
          useany = true;
        };
        codelenses = {
          gc_details = false;
          generate = true;
          regenerate_cgo = true;
          run_govulncheck = true;
          test = true;
          tidy = true;
          upgrade_dependency = true;
          vendor = true;
        };
        completeUnimported = true;
        gofumpt = true;
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
        semanticTokens = true;
        staticcheck = true;
        usePlaceholders = true;
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.go = [
    "goimports"
    "gofumpt"
  ];

  plugins.lint.lintersByFt.go = [ "golangcilint" ];
}
