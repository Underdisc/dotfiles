-- Source shared vimrc files
vim.cmd('source ~/.vim/grund_keybinds.vim')
vim.cmd('source ~/.vim/defaults.vim')

vim.g.have_nerd_font = true
-- Enable mouse for all modes
vim.o.mouse = 'a'
-- Wrapped lines use the indent of the original line with one additional ident.
vim.o.breakindent = true
vim.o.showbreak = '▏ '
vim.o.linebreak = true
-- Display tabs and trailing spaces.
vim.o.list = true
vim.opt.listchars = { space = ' ', tab = '▎->', trail = '⋅' }
-- Tab characters occupy two spaces.
vim.opt.tabstop = 2
-- Disable spell checking by default.
vim.opt.spell = false
-- Show a column at line after line 80.
vim.o.colorcolumn = '81'
-- Relative line numbers with 0 marking the current line.
vim.o.relativenumber = true
vim.o.number = false
-- Highlight the line where the cursor is
vim.o.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
-- Show <tab> and trailing spaces
vim.o.list = true
-- if performing an operation that would fail due to unsaved changes in the
-- buffer (like `:q`) raise a dialog asking if you wish to save the current
-- file(s) See `:help 'confirm'`
vim.o.confirm = true
-- Auto reload buffer if the file changes externally.
vim.opt.autoread = true
-- Save history between sessions.
vim.opt.shada = '!,\'100,f1,<50,:50,@50,/50,h'
-- Don't show mode on command line.
vim.opt.showmode = false
-- Indicate full 24bit color support.
vim.opt.termguicolors = true
-- Prevent leader from timing out.
vim.o.timeout = false
-- Don't display the cursor position on the command line.
vim.opt.ruler = false
-- The globals status line is removed in favor of per window status lines.
vim.opt.laststatus = 0

vim.opt.packpath = { '~/.local/share/nvim/site' }
require('style')
require('util')
require('git')
require('winbar')
require('fs')
require('buffer')
require('lang')
require('keymap')
