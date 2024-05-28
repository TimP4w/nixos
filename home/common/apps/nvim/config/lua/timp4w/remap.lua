vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Telescope
vim.keymap.set('n', '<leader>ff', function() require('search').open({ tab_id = 2 }) end, {})


-- NeoTree
vim.keymap.set('n', '<C-n>', '<Cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<C-E>', '<Cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<C-P>', '<Cmd>')

-- CMD
vim.api.nvim_set_keymap('n', '<C-P>', ':lua function() require("noice").redirect(vim.fn.getcmdline()) end',
	{ noremap = true, silent = true })


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }

		-- Navigatiion
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<C-V><Enter>', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

		-- Help / Hovers
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

		-- Workspace
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		-- Actions
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<space>fo', function() vim.lsp.buf.format { async = true } end, opts)
	end,
})

vim.cmd [[
  command! ToggleDebug lua require('dapui').toggle()
]]

vim.cmd("command -nargs=* GitBranch Telescope git_branches <args>")

-- Trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

--Remove stupid "disable mouse" entry
vim.cmd.aunmenu{'PopUp.How-to\\ disable\\ mouse'}
vim.cmd.aunmenu{'PopUp.-1-'}

-- Noice
vim.keymap.set('n', '<space>nd', function() require("noice").cmd("dismiss") end)
