{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    prettier
    yamllint
  ];

  plugins.lsp.servers.yamlls = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.yaml = [ "prettier" ];

  plugins.lint.lintersByFt.yaml = [ "yamllint" ];

  extraConfigLua = /* lua */ ''
    local ok, lint = pcall(require, 'lint')

    if ok then
      local yamllint = lint.linters.yamllint

      if yamllint then
        yamllint.args = {
          '-f',
          'parsable',
          '-d',
          '{extends: default, rules: {document-start: disable, line-length: disable}}',
          '-',
        }
      end
    end
  '';

  plugins.schemastore.yaml = {
    enable = true;
  };
}
