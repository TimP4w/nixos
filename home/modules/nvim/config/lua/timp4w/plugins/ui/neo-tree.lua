return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",                -- Optional image support in preview window: See `# Preview Mode` for more information
  },

  opts = {
    source_selector = {
      winbar = true,
      statusline = false
    },
    default_component_configs = {
      git_status = {
        symbols = {
          -- Change type
          added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖", -- this can only be used in the git_status source
          renamed   = "󰁕", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        }
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true
      },
    },
    git_status = {
      window = {
        mappings = {
          ["gd"] = "git_open_diff",
        }
      },
      commands = {
        git_open_diff = function(state)
          -- some variables. use any if you want
          local node = state.tree:get_node()
          -- local abs_path = node.path
          -- local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")
          -- local file_name = node.name
          local is_file = node.type == "file"
          if not is_file then
            vim.notify("Diff only for files", vim.log.levels.ERROR)
            return
          end
          -- open file
          local cc = require("neo-tree.sources.common.commands")
          cc.open(state, function()
            -- do nothing for dirs
          end)
          vim.cmd('Gvdiffsplit')
        end,
      }
    }
  }
}
