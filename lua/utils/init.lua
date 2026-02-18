local M = {}

M.core = require('utils.core')

for k, v in pairs(M.core) do
  M[k] = v
end

M.root = require('utils.root')
M.format = require('utils.format')
M.lualine = require('utils.lualine')
M.lsp = require('utils.lsp')
M.oil = require('utils.oil')
M.python = require('utils.python')
M.wk = require('utils.which-key')

return M
