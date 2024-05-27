local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local options = {}

require("lazy").setup({
  {import = "timp4w.plugins"},
  {import = "timp4w.plugins.ui"},
  {import = "timp4w.plugins.ui.themes"},
  {import = "timp4w.plugins.editor"},
  {import = "timp4w.plugins.lsp"},
  {import = "timp4w.plugins.debug"},
}, options)
