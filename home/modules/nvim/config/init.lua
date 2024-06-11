local opts = vim.o
opts.termguicolors = true
require('timp4w')

if vim.g.neovide then
  --if vim.fn.getenv("NEOVIDE_CWD") then
  ---  vim.api.nvim_set_current_dir(vim.fn.getenv("NEOVIDE_CWD"))
  -- end
  opts.guifont = "FiraCode Nerd Font:h14"
  opts.linespace = 0
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_scroll_animation_length = 0.3

  vim.g.neovide_cursor_vfx_mode = "railgun"
end
