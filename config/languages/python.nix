{ pkgs, ... }:

{
  # Fallback tooling for plain scripts when a project does not pin versions.
  extraPackages = with pkgs; [
    pyright
    ruff
  ];

  plugins.conform-nvim.settings.formatters_by_ft.python = {
    __raw = "function(bufnr) return Utils.python.formatters(bufnr) end";
  };

  # Python linters are selected per-buffer by `Utils.python`.
  plugins.lint.lintersByFt.python = [ ];

  autoCmd = [
    {
      callback.__raw = "function(args) Utils.python.lint_buffer(args.buf) end";
      event = "FileType";
      group = "Auto";
      pattern = "python";
    }

    {
      callback.__raw = "function(args) Utils.python.before_save(args.buf) end";
      event = "BufWritePre";
      group = "Auto";
      pattern = "*.py";
    }

    {
      callback.__raw = "function(args) Utils.python.lint_buffer(args.buf) end";
      event = [
        "BufWritePost"
        "InsertLeave"
      ];
      group = "Auto";
      pattern = "*.py";
    }
  ];
}
