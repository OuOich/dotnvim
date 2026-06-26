{
  plugins.lsp.servers.clangd = {
    enable = true;

    cmd = [
      "clangd"
      "--background-index"
      "--clang-tidy"
      "--header-insertion=iwyu"
      "--completion-style=detailed"
    ];
  };

  plugins.lsp.servers.neocmake = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    c = [ "clang-format" ];
    cpp = [ "clang-format" ];
    cuda = [ "clang-format" ];
    objc = [ "clang-format" ];
    objcpp = [ "clang-format" ];
  };

  plugins.lint.lintersByFt = {
    c = [ "clangtidy" ];
    cpp = [ "clangtidy" ];
  };
}
