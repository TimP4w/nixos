require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    -- https://github.com/williamboman/mason-lspconfig.nvim
    "lua_ls",
    --"rust_analyzer",
    --"clangd",
    "jdtls",
    "marksman",
    "pyright",
    "sqlls",
    "tsserver",
    "jsonls",
    "terraformls",
    "yamlls",
    "html",
    "cssls",
    "ansiblels",
    "angularls",
    "typos_lsp"
  },
  automatic_installation = true -- this is only for the ones referred by lspconfig
})
require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {}
  end,
  ["jdtls"] = function()
    print("Skip jdtls setup")
  end
}

require("mason-nvim-dap").setup({
  ensure_installed = {
    "javadbg" -- java-debug-adapter
  }
})

-- require('timp4w.lsp.snykls').setup_snyk_ls()
