{
  plugins.crates-nvim = {
    enable = true;

    settings = {
      autoload = true;
      autoupdate = true;
      autoupdate_throttle = 250;

      loading_indicator = true;
      search_indicator = true;

      smart_insert = true;

      lsp = {
        enabled = true;

        actions = true;
        completion = true;
        hover = true;
      };

      completion = {
        blink = {
          kind_text = {
            version = "Version";
            feature = "Feature";
          };

          kind_icon = {
            version = " ";
            feature = " ";
          };
        };

        crates = {
          enabled = true;

          max_results = 8;
          min_chars = 3;
        };
      };
    };
  };
}
