{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    bash
    shellcheck
    shfmt
  ];

  plugins.lsp.servers.bashls = {
    enable = true;

    settings = {
      bashIde = {
        # Keep diagnostics single-source (nvim-lint)
        shellcheckPath = "";
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    bash = [ "shfmt" ];
    sh = [ "shfmt" ];
  };

  plugins.lint.lintersByFt = {
    bash = [
      "bash"
      "shellcheck"
    ];
    sh = [ "shellcheck" ];
  };
}
