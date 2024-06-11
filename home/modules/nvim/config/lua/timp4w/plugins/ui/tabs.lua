return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      separator_style = "slope",
      diagnostics = "nvim_lsp",
      show_buffer_icons = true,
      themable = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "center",
          separator = true
        }
      },
      -- This fixes neo-tree from breaking (https://github.com/nvim-neo-tree/neo-tree.nvim/issues/821)
      left_mouse_command = function(bufnum)
        local lazy = require("bufferline.lazy")
        local ui = lazy.require("bufferline.ui")
        local windows = vim.fn.win_findbuf(bufnum)
        if windows[1] then
          vim.api.nvim_set_current_win(windows[1])
        end
        vim.schedule(function()
          vim.cmd(string.format("buffer %d", bufnum))
          ui.refresh()
        end)
      end,
      close_command = function(bufnum)
        require('bufdelete').bufdelete(bufnum, true)
      end,
      right_mouse_command = function(bufnum)
        require('bufdelete').bufdelete(bufnum, true)
      end,
    },

  }

}
