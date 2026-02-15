{ config, lib, ... }:

{
  plugins.render-markdown = {
    enable = true;

    lazyLoad.settings.ft = [
      "markdown"
      (lib.mkIf config.plugins.avante.enable "Avante")
    ];

    settings = {
      file_types = [
        "markdown"
        (lib.mkIf config.plugins.avante.enable "Avante")
      ];

      completions = {
        blink = {
          enabled = lib.mkIf config.plugins.blink-cmp.enable true;
        };
        lsp = {
          enabled = true;
        };
      };
    };
  };

  colorschemes.catppuccin.settings.integrations.render_markdown = true;
}
