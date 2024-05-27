M = {}

local env = require('timp4w.env')

M.JAVA_DEBUG_PLUGIN_PATH = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.50.0.jar")
-- M.JAVA_DEBUG_PLUGIN_PATH = vim.fn.expand("$HOME/.config/nvim/libs/java/com.microsoft.java.debug.plugin-0.50.0.jar")

M.JAVA_LOMBOK_PATH = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar")

-- M.SNYK = {}

-- M.SNYK.BINARY_PATH = '/usr/local/bin/snyk-ls'
-- M.SNYK.TOKEN = env.getString('SNYK_TOKEN')

return M
