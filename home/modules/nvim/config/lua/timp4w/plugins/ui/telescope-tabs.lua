return {
    "FabianWirth/search.nvim",
    dependencies = {"nvim- ff/telescope.nvim", "coffebar/neovim-project"},
    config = function()
        require('search').setup {
            append_tabs = { -- append_tabs will add the provided tabs to the default ones
            {
                name = "Changes",
                tele_func = require('telescope.builtin').git_status,
                available = function()
                    return vim.fn.isdirectory(".git") == 1
                end
            }, {
                name = "Branches",
                tele_func = require('telescope.builtin').git_branches,
                available = function()
                    return vim.fn.isdirectory(".git") == 1
                end
            }, {
                name = "Commits",
                tele_func = require('telescope.builtin').git_commits,
                available = function()
                    return vim.fn.isdirectory(".git") == 1
                end
            }, {
                name = "Projects",
                tele_func = require('telescope').load_extension('neovim-project').history
            }}
        }
    end
}
