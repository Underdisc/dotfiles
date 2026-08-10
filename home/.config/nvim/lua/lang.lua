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

local function get_ltex_ls_plus_notif_prefix()
  return 'ltex-ls-plus('
    .. vim.lsp.config['ltex-ls-plus'].settings.ltex.language
    .. ') '
end

local function try_natural_language_lsp_restart()
  if vim.lsp.is_enabled('ltex-ls-plus') then
    vim.lsp.enable('ltex-ls-plus', false)
    vim.lsp.enable('ltex-ls-plus', true)
  end
end

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

function lang.toggle_lua_ls()
  vim.lsp.enable('lua_ls', not vim.lsp.is_enabled('lua_ls'))
end

function lang.toggle_clangd()
  vim.lsp.enable('clangd', not vim.lsp.is_enabled('clangd'))
end

function lang.toggle_ltex_ls_plus()
  vim.lsp.enable('ltex-ls-plus', not vim.lsp.is_enabled('ltex-ls-plus'))
  local notificaton = get_ltex_ls_plus_notif_prefix()
  if vim.lsp.is_enabled('ltex-ls-plus') then
    notificaton = notificaton .. 'enabled'
  else
    notificaton = notificaton .. 'disabled'
  end
  vim.notify(notificaton)
end

function lang.enable_ltex_ls_plus_lang(language)
  vim.lsp.config['ltex-ls-plus'].settings.ltex.language = language
  try_natural_language_lsp_restart()
  vim.notify(get_ltex_ls_plus_notif_prefix())
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
  local diagnostics = vim.diagnostic.get(0, {
    lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
  })
  if #diagnostics > 0 then
    vim.cmd('echom "' .. diagnostics[1].message .. '"')
  end
end

local cmp_enabled = true
function lang.toggle_cmp()
  cmp_enabled = not cmp_enabled
  cmp.setup({ enabled = cmp_enabled })
  if not cmp_enabled and cmp.visible() then
    cmp.close()
  elseif cmp_enabled and not cmp.visible() then
    cmp.complete()
  end
end

return lang
