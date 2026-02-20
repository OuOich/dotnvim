{
  extraConfigLua = /* lua */ ''
    if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
      local ok, osc52 = pcall(require, 'vim.ui.clipboard.osc52')

      if ok then
        local osc52_opts = {}

        if vim.env.TMUX then
          osc52_opts.tmux_passthrough = true
        end

        vim.g.clipboard = {
          name = 'OSC 52',
          copy = {
            ['+'] = osc52.copy('+', osc52_opts),
            ['*'] = osc52.copy('*', osc52_opts),
          },
          paste = {
            ['+'] = osc52.paste('+', osc52_opts),
            ['*'] = osc52.paste('*', osc52_opts),
          },
        }
      end
    end
  '';
}
