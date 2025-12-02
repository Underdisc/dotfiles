-- Set the leader first such that the rest of the config uses the proper leader,
-- prevent space (the leader key) from performing an 'l' motion, and prevent the
-- leader from timing out.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('v', '<space>', '<nop>')
vim.o.timeout = false

-- Source shared vimrc files
vim.cmd("source ~/.vim/grund_keybinds.vim")
vim.cmd("source ~/.vim/defaults.vim")

-- Disable match highlighting by pressing escape.
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
-- Source the init.lua file.
vim.keymap.set('n', '<leader>s', '<cmd>luafile $MYVIMRC<cr>')
-- Disable Ctrl-z suspension
vim.keymap.set({'n', 'v'}, '<c-z>', '<nop>')
-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>b', ':buffers<cr>:buffer ')

vim.g.have_nerd_font = true
-- Enable mouse for all modes
vim.o.mouse = 'a'
-- Wrapped lines use the indent of the original line with one additional ident.
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2"
-- Display tabs and trailing spaces.
vim.o.list = true
vim.opt.listchars = {space = ' ', tab = '-->', trail = '⋅'}
-- Show a column at line after line 80.
vim.o.colorcolumn = "81"
-- Print the line number in front of each line
vim.o.number = true
vim.o.relativenumber = true
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

-- Bootstrap lazy
vim.cmd('filetype plugin indent on')
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      {"Failed to clone lazy.nvim:\n", "ErrorMsg"},
      {out, "WarningMsg"},
      {"\nPress any key to exit..."},
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy
require("lazy").setup({
  spec = {
    -- Show color column as a thin line using characters.
    {"lukas-reineke/virt-column.nvim"},
    -- Quickly comment and uncomment lines
    {"tpope/vim-commentary"},
    -- Close buffers while preserving windows
    {"moll/vim-bbye"},
    -- Improved git integration
    {"lewis6991/gitsigns.nvim"},
    {'tpope/vim-fugitive'},
    -- Colorscheme
    {
      "rockyzhang24/arctic.nvim",
      dependencies = {"rktjmp/lush.nvim"},
    },
    -- Highlight indentation levels
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
    },
    -- Improved status line
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {"nvim-tree/nvim-web-devicons"}
    },
    -- Fuzzy find many different things
    {
      'nvim-telescope/telescope.nvim',
      tag = 'v0.1.9',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- File browser
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
    },
    -- Improved syntax highlighting and more
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate"
    },
  },
  install = {
    colorscheme = {"arctic"}
  },
  checker = {
    enabled = true
  },
  ui = {
    border = "single"
  }
})

vim.cmd("colorscheme arctic")
-- Use the terminal's background color (allows transparency)
vim.api.nvim_set_hl(0, 'Normal', {bg = 'none'})
vim.api.nvim_set_hl(0, 'NormalNC', {bg = 'none'})
vim.api.nvim_set_hl(0, 'Pmenu', {bg = 'none'})
-- Colors of other UI like elements
vim.api.nvim_set_hl(0, 'WinSeparator', {fg = '#bbbbbb'})
vim.api.nvim_set_hl(0, 'CursorLineNr', {fg = '#cccccc'})
vim.api.nvim_set_hl(0, 'LineNr', {fg = '#555555'})
vim.api.nvim_set_hl(0, 'CursorLine', {bg = '#1e1e1e'})

-- Configure the character used for color columns
require("virt-column").setup({
  char = '▎',
  highlight = 'ColorColumn',
})
vim.api.nvim_set_hl(0, 'ColorColumn', {fg = '#888888'})

-- Create indent lines and give them custom colors
local ibl_color_groups = {"ibl1", "ibl2", "ibl3", "ibl4", "ibl5"}
local ibl_hooks = require("ibl.hooks")
ibl_hooks.register(ibl_hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, ibl_color_groups[1], {fg = "#888A8A"})
  vim.api.nvim_set_hl(0, ibl_color_groups[2], {fg = "#318A2D"})
  vim.api.nvim_set_hl(0, ibl_color_groups[3], {fg = "#2F8A5F"})
  vim.api.nvim_set_hl(0, ibl_color_groups[4], {fg = "#32818A"})
  vim.api.nvim_set_hl(0, ibl_color_groups[5], {fg = "#32498A"})
end)
require('ibl').setup({
  indent = {highlight = ibl_color_groups},
  scope = {enabled = false},
})

-- Keybinds for interacting with git
local gitsigns = require('gitsigns')
gitsigns.setup({
  signcolumn = false,
  numhl = true,
})
vim.keymap.set('n', '<leader>gc',
  function()
    gitsigns.toggle_deleted()
    gitsigns.toggle_word_diff()
  end)
vim.keymap.set({'n', 'v'}, '<leader>ga',
  function()
    local mode = string.lower(vim.fn.mode())
    if mode == 'n' then
      gitsigns.stage_hunk()
    elseif mode == 'v' or mode == '\22' then
      local range = {vim.fn.line('v'), vim.fn.line('.')}
      gitsigns.stage_hunk(range)
    end
  end)
vim.keymap.set('n', '<leader>gr', function() gitsigns.reset_hunk() end)
vim.keymap.set({'n', 'v'}, ']g', '<cmd>Gitsigns nav_hunk next<cr>')
vim.keymap.set({'n', 'v'}, '[g', '<cmd>Gitsigns nav_hunk prev<cr>')
vim.keymap.set({'n', 'v'}, ']G', '<cmd>Gitsigns nav_hunk last<cr>')
vim.keymap.set({'n', 'v'}, '[G', '<cmd>Gitsigns nav_hunk first<cr>')
vim.keymap.set({'o', 'x'}, 'ag', function() gitsigns.select_hunk() end)
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>')

-- Numberline colors representing staged and unstaged changes
vim.api.nvim_set_hl(0, 'GitSignsAddNr',          {fg = '#55d055'})
vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr',    {fg = '#558855'})
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr',       {fg = '#ff4d4d'})
vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteNr', {fg = '#905555'})
vim.api.nvim_set_hl(0, 'GitSignsChangeNr',       {fg = '#55ccee'})
vim.api.nvim_set_hl(0, 'GitSignsStagedChangeNr', {fg = '#558899'})

-- Configure the status line
require('lualine').setup({
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'filename'},
    lualine_c = {'diagnostics'},
    lualine_x = {'diff'},
    lualine_y = {'branch', 'encoding', 'fileformat', 'progress'},
    lualine_z = {'location'},
  },
  options = {
    component_separators = {left = '│', right = '│'},
    section_separators = {left = '▏', right = '▕'},
    theme = {
      normal = {
        a = {bg = "#444444", fg = "#eeeeee", gui = 'bold,italic'},
        b = {bg = "#1e1e1e", fg = "#cccccc", gui = 'italic'},
        c = {bg = "#1e1e1e", fg = "#cccccc", gui = 'italic'},
      }
    },
    globalstatus = true,
  }
})

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'c',
    'cpp',
    'css',
    'html',
    'javascript',
    'lua',
  },
  sync_install = false,
  ignore_install = {},
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  modules = {},
})

-- Configure the file explorer
require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      bind_to_cwd = true,
      hide_dotfiles = false,
      hide_gitignored = false
    },
    window = {
      width = 32,
      mappings = {
        -- Change keybinds for modifying the current working directory.
        ["<bs>"] = "noop",
        ["-"] = "navigate_up",
        ["."] = "noop",
        ["*"] = "set_root",
        -- Change keybind for adding new files and directories.
        ["a"] = "noop",
        ["%"] = "add",
        -- Remove neotree fuzzy finding and use default search instead.
        ["/"] = "noop",
      }
    }
  },
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 0,
    },
    name = {
      use_git_status_colors = false,
      use_filtered_colors = false,
    },
    git_status = {
      symbols = {
        -- Change type
        added    = "✚",
        deleted  = "✖",
        modified = "",
        renamed  = "󰁕",
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
        conflict  = "",
      }
    },
    diagnostics = {
      symbols = {
        error = "",
        warn  = "",
        info  = "",
        hint  = "󰌵",
      },
      highlights = {
        hint = "DiagnosticSignHint",
        info = "DiagnosticSignInfo",
        warn = "DiagnosticSignWarn",
        error = "DiagnosticSignError",
      },
    },
  },
})
vim.keymap.set("n", "<leader>e", function()
  vim.cmd('Neotree toggle')
  vim.cmd('wincmd =')
end)
vim.cmd [[
  highlight NeoTreeGitUnstaged  guifg=#e5c2ff
  highlight NeoTreeGitUntracked guifg=#e5c2ff
]]

-- For fuzzy finding files, strings, buffers, and help tags.
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,
      },
    },
    file_ignore_patterns = {
      ".git/",
    },
    borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"}
  },
}
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Configure options for lsps
vim.lsp.config['lua_ls'] = {
  cmd = {'lua-language-server'},
  filetypes = {'lua'},
  root_markers = {'.luarc.json', '.git'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}
vim.lsp.enable('lua_ls')

-- Configure diagnostic options
vim.diagnostic.config({
  signs = false,
  underline = true,
  virtual_text = false,
  virtual_lines = false,
})

-- Lines with associated diagnostics recieve double underlines
vim.cmd [[
  highlight DiagnosticUnderlineError gui=underdouble
  highlight DiagnosticUnderlineWarn  gui=underdouble
  highlight DiagnosticUnderlineInfo  gui=underdouble
  highlight DiagnosticUnderlineHint  gui=underdouble
]]

-- Prevent diagnostic underlines from dissappearing when in an insert mode
local original_underline_hide = vim.diagnostic.handlers.underline.hide
vim.diagnostic.handlers.underline.hide = function(ns, bufnr)
  local current_mode = vim.api.nvim_get_mode().mode
  local ignored_mode = current_mode == 'i' or current_mode == 'R'
  if ignored_mode or not original_underline_hide then
    return
  end
  original_underline_hide(ns, bufnr)
end

-- Keybinds for displaying diagnostics
vim.keymap.set('n', '<leader>dv', function()
  local active = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({virtual_lines = active})
end, {desc = 'Toggle diagnostic virtual_lines'})
vim.keymap.set('n', '<leader>dl', function()
  local active = not vim.diagnostic.config().underline
  vim.diagnostic.config({underline = active})
end, {desc = 'Toggle diagnostic underline'})
vim.keymap.set('n', '<leader>dd', function()
  local diagnostics = vim.diagnostic.get(0, {
    lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  })
  if #diagnostics > 0 then
    vim.cmd('echom "' .. diagnostics[1].message .. '"')
  end
end, {desc = 'Display diagnostic message'})
