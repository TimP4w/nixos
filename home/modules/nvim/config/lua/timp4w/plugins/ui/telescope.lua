return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
        require('telescope').setup {
            pickers = {
                git_status = {
                    mappings = {
                        i = {
                            ["<C-a>"] = require('telescope.actions').git_staging_toggle
                        },
                        n = {
                            ["<C-a>"] = require('telescope.actions').git_staging_toggle
                        }
                    }
                }
            }
        }
    end
}
