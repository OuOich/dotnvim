{ lib', ... }:

{
  plugins.noice = {
    enable = true;

    settings = {
      presets = {
        command_palette = true;
        long_message_to_split = true;
        lsp_doc_border = true;
      };

      cmdline = {
        format = {
          cmdline.icon = lib'.icons.prompt.Input.line;
          search_down.icon = lib'.icons.common.SearchDown.line;
          search_up.icon = lib'.icons.common.SearchUp.line;
          filter.icon = lib'.icons.common.Shell.line;
          lua.icon = lib'.icons.languages.Lua.fill;
          help.icon = lib'.icons.common.Help.line;
          calculator.icon = lib'.icons.common.Calculator.line;
          input.icon = lib'.icons.common.Input.line;
        };
      };

      views = {
        popup_no_border = {
          view = "popup";
          border.style = "none";
        };

        hover = {
          border = {
            padding = [
              0
              1
            ];
          };
        };
      };

      routes = [
        {
          filter = {
            event = "msg_show";
            any = [
              { find = "%d+L, %d+B"; }
              { find = "; after #%d+"; }
              { find = "; before #%d+"; }
              { find = "Hunk %d+ of %d+"; }
              { find = "No hunks"; }
            ];
          };

          view = "mini";
        }

        {
          filter = {
            event = "notify";
            any = [
              { find = "[Neo-tree INFO]"; }
            ];
          };

          opts = {
            skip = true;
          };
        }

        {
          filter = {
            event = "lsp";
            kind = "progress";
            any = [
              { find = "[Pp]yright"; }
              { find = "[Bb]asedpyright"; }
            ];
          };

          opts = {
            skip = true;
          };
        }
      ];
    };
  };

  colorschemes.catppuccin.settings.integrations.noice = true;
}
