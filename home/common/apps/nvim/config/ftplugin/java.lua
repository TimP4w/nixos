local vars = require("timp4w.vars")

M = {}
M.on_attach = function(client, bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require("jdtls.dap").setup_dap_main_class_configs()
end

local config = {
  cmd = {
    'jdtls',
    '--jvm-arg=' .. string.format("-javaagent:%s", vars.JAVA_LOMBOK_PATH)
  },
  settings = {
    -- settings configuration
  },
  flags = {
    allow_incremental_sync = true
  },
  on_attach = M.on_attach,
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  init_options = {
    bundles = {
      vim.fn.glob(vars.JAVA_DEBUG_PLUGIN_PATH, 1)
    },
  },
}

require('dap.ext.vscode').load_launchjs()
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
require("jdtls.setup").add_commands()
