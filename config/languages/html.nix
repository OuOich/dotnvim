{ pkgs, lib, ... }:

{
  extraPackages = with pkgs; [
    prettierd
  ];

  plugins.conform-nvim.settings.formatters_by_ft.html =
    lib.nixvim.utils.listToUnkeyedAttrs [
      "oxfmt"
      "deno_fmt"
      "prettierd"
    ]
    // {
      stop_after_first = true;
    };
}
