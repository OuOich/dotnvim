{ pkgs, lib, ... }:

{
  extraPackages = with pkgs; [
    prettierd
  ];

  plugins.lsp.servers.ts_ls = {
    enable = true;
  };

  plugins.lsp.servers.eslint = {
    enable = true;

    filetypes = lib.mkAfter [
      "javascript"
      "javascriptreact"
      "javascript.jsx"
      "typescript"
      "typescriptreact"
      "typescript.tsx"
    ];
  };

  plugins.lsp.servers.oxlint = {
    enable = true;
  };

  plugins.lsp.servers.denols = {
    enable = true;
    package = null;
  };

  plugins.conform-nvim.settings.formatters_by_ft =
    let
      formatters =
        lib.nixvim.utils.listToUnkeyedAttrs [
          "oxfmt"
          "deno_fmt"
          "eslint_d"
          "prettierd"
        ]
        // {
          stop_after_first = true;
        };
    in
    {
      javascript = formatters;
      javascriptreact = formatters;
      typescript = formatters;
      typescriptreact = formatters;
    };
}
