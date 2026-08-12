-- Quick commenting
vim.pack.add({ 'https://github.com/tpope/vim-commentary' })

-- Autoformatting
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    cpp = { 'clang_format' },
    c = { 'clang_format' },
  },
  formatters = {
    clang_format = {
      prepend_args = { '--style=file' },
    },
  },
})

-- Treesitter
vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
})
local nvim_treesitter = require('nvim-treesitter')
nvim_treesitter.install({
  'bash',
  'c',
  'cpp',
  'css',
  'html',
  'javascript',
  'lua',
})

-- Lsp Status Messaging
vim.pack.add({ 'https://github.com/j-hui/fidget.nvim' })
require('fidget').setup()

-- Lua
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
    },
  },
}

-- C and Cpp
vim.lsp.config['clangd'] = {
  filetypes = { 'cpp', 'c' },
  root_markers = { 'compile_commands.json', '.git' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
  cmd = {
    'clangd',
    '--enable-config',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--header-insertion-decorators=false',
    '--completion-style=detailed',
  },
}

-- Natural Languages
vim.lsp.config['ltex-ls-plus'] = {
  cmd = { 'ltex-ls-plus' },
  filetypes = { 'markdown', 'text' },
  settings = {
    ltex = {
      language = 'en-US',
    },
  },
}

-- Diagnostics
vim.diagnostic.config({
  signs = false,
  underline = true,
  virtual_text = false,
  virtual_lines = false,
})

-- Lines with associated diagnostics recieve double underlines
vim.cmd([[
  highlight DiagnosticUnderlineError gui=underdouble
  highlight DiagnosticUnderlineWarn  gui=underdouble
  highlight DiagnosticUnderlineInfo  gui=underdouble
  highlight DiagnosticUnderlineHint  gui=underdouble
]])

-- Prevent diagnostic underlines from dissappearing when in insert mode.
local original_underline_hide = vim.diagnostic.handlers.underline.hide
vim.diagnostic.handlers.underline.hide = function(ns, bufnr)
  local current_mode = vim.api.nvim_get_mode().mode
  local ignored_mode = current_mode == 'i' or current_mode == 'R'
  if ignored_mode or not original_underline_hide then return end
  original_underline_hide(ns, bufnr)
end

-- Autocomplete
vim.pack.add({ 'https://github.com/hrsh7th/cmp-nvim-lsp' })
vim.pack.add({ 'https://github.com/hrsh7th/nvim-cmp' })
local cmp = require('cmp')
cmp.setup({
  enabled = function()
    return not require('cmp.config.context').in_treesitter_capture('comment')
  end,
  window = {
    completion = {
      winblend = 20,
      max_height = 10,
    },
    documentation = {
      winblend = 20,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<down>'] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
    }),
    ['<up>'] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
    }),
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }),
})

local lang = {}

function lang.format()
  conform.format()
  local filename = vim.fn.expand('%:p:.')
  vim.notify('"' .. filename .. '" formatted')
end

function lang.enable_lsp(lsp, info)
  vim.lsp.enable(lsp, not vim.lsp.is_enabled(lsp))
  local notification = lsp
  if info ~= nil then
    notification = notification .. '(' .. info .. ')'
  end
  if vim.lsp.is_enabled(lsp) then
    notification = notification .. ' enabled'
  else
    notification = notification .. ' disabled'
  end
  vim.notify(notification)
end

function lang.toggle_lua_ls() lang.enable_lsp('lua_ls') end
function lang.toggle_clangd() lang.enable_lsp('clangd') end
function lang.toggle_ltex_ls_plus()
  local info = vim.lsp.config['ltex-ls-plus'].settings.ltex.language
  lang.enable_lsp('ltex-ls-plus', info)
end

function lang.enable_ltex_ls_plus_lang(language)
  vim.lsp.config['ltex-ls-plus'].settings.ltex.language = language
  if vim.lsp.is_enabled('ltex-ls-plus') then
    vim.lsp.enable('ltex-ls-plus', false)
    vim.lsp.enable('ltex-ls-plus', true)
  end
  vim.notify('ltex-ls-plus using ' .. language)
end

function lang.enable_ltex_ls_plus_en() lang.enable_ltex_ls_plus_lang('en-US') end
function lang.enable_ltex_ls_plus_de() lang.enable_ltex_ls_plus_lang('de-DE') end
function lang.enable_ltex_ls_plus_es() lang.enable_ltex_ls_plus_lang('es-ES') end

function lang.toggle_diagnostic_virtual_lines()
  local active = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = active })
end

function lang.toggle_diagnostic_underlines()
  local active = not vim.diagnostic.config().underline
  vim.diagnostic.config({ underline = active })
end

function lang.show_diagnostic_under_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  pos[1] = pos[1] - 1
  found_diagnostic = false
  local diagnostics = vim.diagnostic.get(0, { lnum = pos[1] })
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.col <= pos[2] and pos[2] < diagnostic.end_col then
      vim.notify(diagnostic.message)
      found_diagnostic = true
      break;
    end
  end
  if not found_diagnostic then
    vim.notify('No diagnostic under cursor.')
  end
end

local severities = {
  { enum = vim.diagnostic.severity.HINT, string = 'Hint' },
  { enum = vim.diagnostic.severity.INFO, string = 'Info' },
  { enum = vim.diagnostic.severity.WARN, string = 'Warn' },
  { enum = vim.diagnostic.severity.ERROR, string = 'Error' },
}
local severity_range = { 4, 4 }
function lang.modify_min_diagnostic_severity_filter(amount)
  local min = severity_range[1]
  min = min + amount
  if min < 1 then
    min = 1
  elseif min > #severities then
    min = #severities
  end
  severity_range[1] = min
  vim.notify(
    '"' .. severities[min].string .. '"' .. ' diagnostic jump minimum severity'
  )
end
function lang.diagnostic_severity_filter_down()
  lang.modify_min_diagnostic_severity_filter(-vim.v.count1)
end
function lang.diagnostic_severity_filter_up()
  lang.modify_min_diagnostic_severity_filter(vim.v.count1)
end

function lang.diagnostic_jump(amount)
  vim.diagnostic.jump({
    count = amount,
    severity = {
      min = severities[severity_range[1]].enum,
      max = severities[severity_range[2]].enum,
    },
  })
end
function lang.diagnostic_jump_forward() lang.diagnostic_jump(vim.v.count1) end
function lang.diagnostic_jump_backward() lang.diagnostic_jump(-vim.v.count1) end

local cmp_enabled = true
function lang.toggle_cmp()
  cmp_enabled = not cmp_enabled
  cmp.setup({ enabled = cmp_enabled })
  if not cmp_enabled and cmp.visible() then
    cmp.close()
  elseif cmp_enabled and not cmp.visible() then
    cmp.complete()
  end
  if cmp_enabled then
    vim.notify('completion enabled')
  else
    vim.notify('completion disabled')
  end
end

return lang
