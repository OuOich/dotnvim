{ pkgs, lib, ... }:

{
  extraPackages = with pkgs; [
    prettierd
  ];

  plugins.lsp.servers.jsonls = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.json =
    lib.nixvim.utils.listToUnkeyedAttrs [
      "oxfmt"
      "deno_fmt"
      "prettierd"
    ]
    // {
      stop_after_first = true;
    };

  plugins.schemastore.json = {
    enable = true;
  };
}
