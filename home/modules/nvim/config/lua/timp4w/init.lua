require('timp4w.remap')
require('timp4w.lazy')
require('timp4w.lsp')
require('timp4w.icons')
require('timp4w.env')
local v = vim
local opts = v.o

-------------------
-- Editor stuff  --
-- ----------------
opts.number = true
opts.relativenumber = true
opts.updatetime = 250
-- tabs 
opts.expandtab = true
opts.smartindent = true
opts.tabstop = 2
opts.shiftwidth = 2
-- clipboard
v.cmd [[set clipboard+=unnamedplus]]

----------------------
-- LSP / Dignostics --
-- -------------------
-- Update diagnostics on insert 
v.diagnostic.config({
  update_in_insert = true
})
-- Floating popup for diagnostics

v.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local options = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = '',
      scope = 'cursor',
    }
    v.diagnostic.open_float(nil, options)
  end
})

-------------------
--   Debugger    --
-- ----------------
require('telescope').load_extension('dap')
local dapui = require("dapui")
dapui.setup()

-------------------
--      Theme    --
-- ----------------
v.cmd("colorscheme onedark")
