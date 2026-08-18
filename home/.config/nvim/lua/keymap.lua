vim.cmd('source ~/.vim/keymap.vim')

function apply_keymaps(keymaps)
  for _, km in ipairs(keymaps) do
    vim.keymap.set(km[1], km[2], km[3])
  end
end

local lang = require('lang')
local fs = require('fs')
local conform = require('conform')
local yazi = require('yazi')
local flash = require('flash')
local util = require('util')
local vuffers = require('vuffers')
local buffer = require('buffer')
local git = require('git')
local gitsigns = require('gitsigns')

-- Set the leader so that the rest of the keymaps use the proper leader.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
apply_keymaps({
  -- Prevent space from performing an 'l' motion.
  { { 'n', 'v' }, '<space>', '<nop>' },
  -- Disable match highlighting by pressing escape.
  { { 'n' }, '<esc>', '<cmd>nohlsearch<cr>' },
  -- Source the init.lua file.
  { { 'n' }, '<leader>s', '<cmd>luafile $MYVIMRC<cr>' },
  -- Use <Esc> to exit terminal mode
  { { 't' }, '<Esc>', '<C-\\><C-n>' },
  -- Use <c-bs> to delete the previous word in command line mode.
  { { 'c' }, '<c-w>', '<nop>' },
  { { 'c' }, '<c-bs>', '<c-w>' },
  -- Writing and deleting buffers
  { { 'n' }, '<c-s>', '<cmd>write<cr>' },
  { { 'n' }, '<c-x>', '<cmd>Bdelete<cr>' },
  -- Decrement interger
  { { 'n' }, '<c-`>', '<c-x>' },
  -- Sensible Undo
  { { 'n' }, 'u', 'u' },
  { { 'n' }, 'U', '<c-r>' },
  -- Go to definition
  { { 'n' }, 'gd', '<c-]>' },
  { { 'n' }, '<leader>o', '<cmd>Oil<cr>' },
  { { 'n' }, '<leader>ff', fs.telescope_file },
  { { 'n' }, '<leader>fg', fs.telescope_grep },
  { { 'n' }, '<leader>fb', fs.telescope_buffer },
  { { 'n' }, '<leader>fh', fs.telescope_help },
  { { 'n' }, '<c-z>', lang.format },
  { { 'n' }, '<leader>y', yazi.toggle },
  { { 'n', 'x', 'o' }, '\\', flash.jump },
  { { 'n', 'x', 'o' }, '<c-/>', flash.treesitter },
  { { 'n', 'x', 'o' }, '<a-/>', flash.treesitter_search },
  { { 'n' }, '<leader>u', vim.cmd.UndotreeToggle },
  -- Buffers
  { { 'n' }, '<leader>b', vuffers.toggle },
  { { 'n', 'i' }, '<c-j>', buffer.switch_buffer_down },
  { { 'n', 'i' }, '<c-k>', buffer.switch_buffer_up },
  { { 'n', 'i' }, '<c-down>', buffer.move_buffer_down },
  { { 'n', 'i' }, '<c-up>', buffer.move_buffer_up },
  { { 'n' }, '<leader>B', vuffers.go_to_buffer_by_line },
  -- Git
  { { 'n' }, '<leader>gs', git.toggle_inline_diff },
  { { 'n', 'v' }, '<leader>ga', git.toggle_hunk },
  { { 'n', 'v' }, '<leader>gu', git.toggle_hunk },
  { { 'n' }, '<leader>gch', gitsigns.reset_hunk },
  { { 'n', 'v' }, '>', '<cmd>Gitsigns nav_hunk next<cr>' },
  { { 'n', 'v' }, '<', '<cmd>Gitsigns nav_hunk prev<cr>' },
  { { 'n', 'v' }, ']G', '<cmd>Gitsigns nav_hunk last<cr>' },
  { { 'n', 'v' }, '[G', '<cmd>Gitsigns nav_hunk first<cr>' },
  { { 'o', 'x' }, 'ag', gitsigns.select_hunk },
  { { 'n' }, '<leader>gb', '<cmd>Git blame -s<cr>' },
  { { 'n' }, '<leader>gl', git.show_commit_message },
  -- Lsp
  { { 'n', 'i', 's', 'c' }, '<m-tab>', lang.toggle_cmp },
  { { 'n' }, '<leader>lat', lang.toggle_lua_ls },
  { { 'n' }, '<leader>lct', lang.toggle_clangd },
  { { 'n' }, '<leader>lgt', lang.toggle_gopls },
  { { 'n' }, '<leader>lnt', lang.toggle_ltex_ls_plus },
  { { 'n' }, '<leader>lnu', lang.enable_ltex_ls_plus_en },
  { { 'n' }, '<leader>lnd', lang.enable_ltex_ls_plus_de },
  { { 'n' }, '<leader>lne', lang.enable_ltex_ls_plus_es },
  -- Diagnostics
  { { 'n' }, '<leader>dv', lang.toggle_diagnostic_virtual_lines },
  { { 'n' }, '<leader>dl', lang.toggle_diagnostic_underlines },
  { { 'n' }, '<leader>dd', lang.show_diagnostic_under_cursor },
  { { 'n' }, '»', lang.diagnostic_jump_forward },
  { { 'n' }, '«', lang.diagnostic_jump_backward },
  { { 'n' }, '<leader>dj', lang.diagnostic_severity_filter_down },
  { { 'n' }, '<leader>dk', lang.diagnostic_severity_filter_up },
})
