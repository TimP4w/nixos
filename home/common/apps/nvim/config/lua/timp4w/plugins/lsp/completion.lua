local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
                    "hrsh7th/cmp-cmdline", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "onsails/lspkind.nvim"},
    lazy = false
}

M.config = function()
    local cmp = require("cmp")
    -- vim.opt.completeopt = { "menu", "menuone", "noselect" }
    local lspkind = require('lspkind')
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end
        },
        window = {
            completion = cmp.config.window.bordered()
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({
                select = true
            }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items. (https://github.com/NvChad/NvChad/issues/1393#issuecomment-1198805017)
        }),
        sources = cmp.config.sources({{
            name = "nvim_lsp"
        }, {
            name = "nvim_lua"
        }, {
            name = "luasnip"
        } -- For luasnip users.
        -- { name = "orgmode" },
        }, {{
            name = "buffer"
        }, {
            name = "path"
        }}),
        formatting = {
            -- add icons, very important
            format = lspkind.cmp_format({
                mode = 'symbol_text',
                maxwidth = 50,
                ellipsis_char = "..."
            })
        }
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{
            name = "path"
        }}, {{
            name = "cmdline"
        }})
    })
end

return M
