{ pkgs, ... }:

{
  plugins.lsp.servers.unocss = {
    enable = true;
    package = pkgs.unocss-language-server;
  };
}
