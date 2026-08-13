{ pkgs, lib, ... }:

{
  extraPackages = with pkgs; [
    prettierd
  ];

  plugins.lsp.servers.jsonls = {
    enable = true;
  };

  plugins.lsp.servers.eslint = {
    enable = true;

    filetypes = lib.mkAfter [
      "json"
    ];
  };

  plugins.conform-nvim.settings.formatters_by_ft.json =
    lib.nixvim.utils.listToUnkeyedAttrs [
      "oxfmt"
      "deno_fmt"
      "eslint_d"
      "prettierd"
    ]
    // {
      stop_after_first = true;
    };

  plugins.schemastore.json = {
    enable = true;
  };
}
