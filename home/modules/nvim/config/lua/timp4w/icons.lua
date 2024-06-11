local v = vim

local diagnosticSigns = {
  Error = " ", -- 󰅚
  Warn = " ", -- 󰀪
  Hint = "󰌵 ", -- 󰌶
  Info = " ", -- 
}

local dapSigns = {
  Breakpoint = '',
  BreakPointCondition = 'ﳁ',
  BreakPointRejected = '',
  LogPoint = '',
  Stopped = ''
}

local function setupSigns(prefix, signs)
  for type, icon in pairs(signs) do
    local hl = prefix .. type

    v.fn.sign_define(hl, { text = icon, numhl = hl })
  end
end

setupSigns("DiagnosticSign", diagnosticSigns)
setupSigns("Dap", dapSigns)

v.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
v.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
v.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
