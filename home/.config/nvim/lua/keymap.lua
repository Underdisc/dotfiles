-- Set the leader first such that the rest of the keymaps uses the proper
-- leader, prevent space (the leader key) from performing an 'l' motion.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('v', '<space>', '<nop>')

-- Disable match highlighting by pressing escape.
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
-- Source the init.lua file.
vim.keymap.set('n', '<leader>s', '<cmd>luafile $MYVIMRC<cr>')
-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
-- Use <c-bs> to delete the previous word in command line mode.
vim.keymap.set('c', '<c-w>', '<nop>')
vim.keymap.set('c', '<c-bs>', '<c-w>')
-- Writing and deleting buffers
vim.keymap.set('n', '<c-s>', '<cmd>write<cr>')
vim.keymap.set('n', '<c-x>', '<cmd>Bdelete<cr>')
-- Decrement interger
vim.keymap.set('n', '<c-`>', '<c-x>')
-- Sensible Undo
vim.keymap.set('n', 'u', 'u')
vim.keymap.set('n', 'U', '<c-r>')
-- Go to definition
vim.keymap.set('n', 'gd', '<c-]>')

vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>')

vim.keymap.set(
  'n',
  '<leader>ff',
  '<cmd>Telescope find_files hidden=true no_ignore=true<cr>'
)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

local conform = require('conform')
vim.keymap.set('n', '<c-z>', conform.format)

local yazi = require('yazi')
vim.keymap.set('n', '<leader>y', yazi.toggle)

local flash = require('flash')
vim.keymap.set({ 'n', 'x', 'o' }, '\\', flash.jump)
vim.keymap.set({ 'n', 'x', 'o' }, '<c-/>', flash.treesitter)
vim.keymap.set({ 'n', 'x', 'o' }, '<a-/>', flash.treesitter_search)

-- Retrieve the id for a window displaying a buffer with the desired filetype.
local function get_filetype_win(filetype)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
    if ft == filetype then return winid end
  end
  return -1
end

vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>u', function()
  -- Open the undotree window or focus it if it already exists.
  local undotree_winid = get_filetype_win('undotree')
  if undotree_winid == -1 then
    vim.cmd('UndotreeToggle')
  else
    vim.api.nvim_set_current_win(undotree_winid)
  end
end)

-- Buffer navigation keybinds
local vuffers = require('vuffers')
vim.keymap.set('n', '<leader>B', vuffers.toggle)
vim.keymap.set(
  { 'n', 'i' },
  '<c-j>',
  function() vuffers.go_to_buffer_by_count({ direction = 'next' }) end
)
vim.keymap.set(
  { 'n', 'i' },
  '<c-k>',
  function() vuffers.go_to_buffer_by_count({ direction = 'prev' }) end
)
vim.keymap.set(
  { 'n', 'i' },
  '<c-down>',
  function() vuffers.move_current_buffer_by_count({ direction = 'next' }) end
)
vim.keymap.set(
  { 'n', 'i' },
  '<c-up>',
  function() vuffers.move_current_buffer_by_count({ direction = 'prev' }) end
)
vim.keymap.set('n', '<leader>b', vuffers.go_to_buffer_by_line)

local git = require('git')
local gitsigns = require('gitsigns')
vim.keymap.set('n', '<leader>gs', git.toggle_inline_diff)
vim.keymap.set({ 'n', 'v' }, '<leader>ga', git.toggle_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>gu', git.toggle_hunk)
vim.keymap.set('n', '<leader>gch', gitsigns.reset_hunk)
vim.keymap.set({ 'n', 'v' }, '>', '<cmd>Gitsigns nav_hunk next<cr>')
vim.keymap.set({ 'n', 'v' }, '<', '<cmd>Gitsigns nav_hunk prev<cr>')
vim.keymap.set({ 'n', 'v' }, ']G', '<cmd>Gitsigns nav_hunk last<cr>')
vim.keymap.set({ 'n', 'v' }, '[G', '<cmd>Gitsigns nav_hunk first<cr>')
vim.keymap.set({ 'o', 'x' }, 'ag', gitsigns.select_hunk)
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame -s<cr>')
vim.keymap.set('n', '<leader>gl', git.show_commit_message)

local lang = require('lang')
vim.keymap.set({ 'n', 'i', 's', 'c' }, '<c-tab>', lang.toggle_cmp)
vim.keymap.set('n', '<leader>lat', lang.toggle_lua_ls)
vim.keymap.set('n', '<leader>lct', lang.toggle_clangd)
vim.keymap.set('n', '<leader>lnt', lang.toggle_ltex_ls_plus)
vim.keymap.set('n', '<leader>lnu', lang.enable_ltex_ls_plus_en)
vim.keymap.set('n', '<leader>lnd', lang.enable_ltex_ls_plus_de)
vim.keymap.set('n', '<leader>lne', lang.enable_ltex_ls_plus_es)

-- Display Diagnostics
vim.keymap.set('n', '<leader>dv', lang.toggle_diagnostic_virtual_lines)
vim.keymap.set('n', '<leader>dl', lang.toggle_diagnostic_underlines)
vim.keymap.set('n', '<leader>dd', lang.show_diagnostic_under_cursor)
