-- Configure debuggers.
vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap' })
local dap = require('dap')
local widgets = require('dap.ui.widgets')
dap.defaults.fallback.auto_continue_if_many_stopped = false
local jsDebugger = vim.env.JSDEBUGGER
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      jsDebugger,
      '${port}',
    },
  },
}

-- Set highlight groups used by breakpoints.
local signs = {
  'DapBreakpoint',
  'DapBreakpointCondition',
  'DapLogPoint',
  'DapStopped',
  'DapBreakpointRejected',
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign, { text = '', numhl = sign })
end

-- Configure debugger views.
vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view' })
local view = require('dap-view')
view.setup({
  winbar = {
    sections = { 'repl', 'watches', 'breakpoints', 'threads', 'sessions' },
    default_section = 'repl',
    base_sections = {
      repl = { label = 'Repl', keymap = 'R' },
      watches = { label = 'Watches', keymap = 'W' },
      breakpoints = { label = 'Breakpoints', keymap = 'B' },
      threads = { label = 'Threads', keymap = 'T' },
      sessions = { label = 'Sessions', keymap = 'S' },
    },
    show_keymap_hints = false,
  },
  windows = {
    size = 0.45,
    position = 'right',
  },
  keymaps = {
    base = {
      next_view = '<c-l>',
      prev_view = '<c-h>',
    },
  },
})

local dbg = {}

function dbg.set_conditional_breakpoint()
  dap.set_breakpoint(vim.fn.input('Condition:'))
end

function dbg.set_log_breakpoint()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log:'))
end

function dbg.hover()
  local winId = widgets.hover().win
  vim.api.nvim_create_autocmd('WinLeave', {
    once = true,
    callback = function() vim.api.nvim_win_close(winId, true) end,
  })
end

function dbg.log(object, opts)
  local text = ''
  if opts ~= nil and opts.date == true then
    text = text .. os.date('%y-%m-%d;%H:%M:%S') .. '\n'
  end
  text = text .. vim.inspect(object)

  if opts ~= nil and opts.file ~= nil then
    local path = vim.fn.expand(opts.file)
    local file = io.open(path, 'a')
    if file then
      file:write(text .. '\n')
      file:close()
    end
  else
    print(text)
  end
end

return dbg
