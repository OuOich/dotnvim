{ lib, ... }:

{
  plugins.lsp.servers.volar = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    vue =
      lib.nixvim.utils.listToUnkeyedAttrs [
        "oxfmt"
        "deno_fmt"
        "eslint_d"
        "prettierd"
      ]
      // {
        stop_after_first = true;
      };
  };
}
