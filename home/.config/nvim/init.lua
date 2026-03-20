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
-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>b', ':buffers<cr>:buffer ')
-- Use <c-bs> to delete the previous word in command line mode.
vim.keymap.set('c', '<c-w>', '<nop>')
vim.keymap.set('c', '<c-bs>', '<c-w>')

local sidebar_width = 39
vim.g.have_nerd_font = true
-- Enable mouse for all modes
vim.o.mouse = 'a'
-- Wrapped lines use the indent of the original line with one additional ident.
vim.o.breakindent = true
vim.o.showbreak = " "
vim.o.linebreak = true
-- Display tabs and trailing spaces.
vim.o.list = true
vim.opt.listchars = {space = ' ', tab = '-->', trail = '⋅'}
-- Disable spell checking by default.
vim.opt.spell = false
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
-- Save history between sessions.
vim.opt.shada = "!,'100,f1,<50,:50,@50,/50,h"
-- Don't show mode on command line.
vim.opt.showmode = false

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
    -- Undotree
    {"mbbill/undotree"},
    -- Improved git integration
    {"lewis6991/gitsigns.nvim"},
    {'tpope/vim-fugitive'},
    -- Autoformatting
    {'stevearc/conform.nvim'},
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
    -- Improved window status bar
    {'b0o/incline.nvim'},
    -- Fuzzy find many different things
    {
      'nvim-telescope/telescope.nvim',
      tag = 'v0.1.9',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- File browser
    {
      'nvim-tree/nvim-tree.lua',
      version = '*',
      lazy = false,
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
    },
    -- Improved syntax highlighting and more
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate"
    },
    -- Language features
    {'neovim/nvim-lspconfig'},
    -- Autocompletion
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
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

-- Autoformatting
local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    cpp = {'clang_format'},
    c = {'clang_format'},
  },
  formatters = {
    clang_format = {
      prepend_args = {'--style=file'}
    }
  }
})
vim.keymap.set('n', '<leader>z', function()
  conform.format()
end)

vim.cmd("colorscheme arctic")
-- Use the terminal's background color (allows transparency)
vim.api.nvim_set_hl(0, 'Normal', {bg = 'none'})
vim.api.nvim_set_hl(0, 'NormalNC', {bg = 'none'})
vim.api.nvim_set_hl(0, 'Pmenu', {bg = "#1e1e1e", italic = true})

-- Colors of other UI like elements
vim.api.nvim_set_hl(0, 'WinSeparator', {fg = '#bbbbbb'})
vim.api.nvim_set_hl(0, 'CursorLineNr', {fg = '#cccccc'})
vim.api.nvim_set_hl(0, 'LineNr', {fg = '#555555'})
vim.api.nvim_set_hl(0, 'CursorLine', {bg = '#222222'})
vim.api.nvim_set_hl(0, 'NonText', {fg = '#555555'})

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

-- Retrieve the id for a window displaying a buffer with the desired filetype.
local function get_filetype_win(filetype)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_buf_get_option(bufid, "filetype")
    if ft == filetype then
      return winid
    end
  end
  return -1
end

-- Undotree configuration
vim.g.undotree_DiffAutoOpen = 0
vim.g.undotree_SetFocusWhenToggle = true
vim.g.undotree_HelpLine = 0
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_HighlightChangedText = 0

vim.keymap.set("n", "u", "g-")
vim.keymap.set("n", "U", "g+")
vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>u", function()
  -- Open the undotree window or focus it if it already exists.
  local undotree_winid = get_filetype_win('undotree')
  if undotree_winid == -1 then
    vim.cmd('UndotreeToggle')
  else
    vim.api.nvim_set_current_win(undotree_winid)
  end
end)

-- Prevent unnecessary indentation lines from appearing in the undotree.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'undotree',
  callback = function()
    require('ibl').setup_buffer(0, {enabled = false})
  end,
})

-- Gitsigns configuration
local gitsigns = require('gitsigns')
gitsigns.setup({
  signcolumn = false,
  numhl = true,
})

local function toggle_hunk()
  local mode = string.lower(vim.fn.mode())
  if mode == 'n' then
    gitsigns.stage_hunk()
  elseif mode == 'v' or mode == '\22' then
    local range = {vim.fn.line('v'), vim.fn.line('.')}
    gitsigns.stage_hunk(range)
  end
end

vim.keymap.set('n', '<leader>gs',
  function()
    gitsigns.toggle_deleted()
    gitsigns.toggle_word_diff()
  end)
vim.keymap.set({'n', 'v'}, '<leader>ga', toggle_hunk)
vim.keymap.set({'n', 'v'}, '<leader>gu', toggle_hunk)
vim.keymap.set('n', '<leader>gch', function() gitsigns.reset_hunk() end)
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

-- Configure the command line.
vim.opt.cmdheight = 1
vim.opt.ruler = false
vim.api.nvim_set_hl(0, 'MsgArea', {bg = "#222222", fg = "#cccccc"})
vim.api.nvim_set_hl(0, 'ModeMsg', {bg = "#222222", fg = "#cccccc"})

-- The globals status line is removed in favor of per window status lines.
vim.opt.laststatus = 0

-- Highlight groups used in window titlebars
vim.api.nvim_set_hl(0, 'WinBar', {bg = "#444444", fg = "#eeeeee"})
vim.api.nvim_set_hl(0, 'WinBarNC', {bg = "#222222", fg = "#cccccc"})
vim.api.nvim_set_hl(0, 'NormalModeIndicator',
  {bg = "#cccccc", fg = "#222222", bold = true})
vim.api.nvim_set_hl(0, 'InsertModeIndicator',
  {bg = "#44cc44", fg = "#222222", bold = true})
vim.api.nvim_set_hl(0, 'VisualModeIndicator',
  {bg = "#4499cc", fg = "#222222", bold = true})
vim.api.nvim_set_hl(0, 'CommandModeIndicator',
  {bg = "#cc4444", fg = "#222222", bold = true})
vim.api.nvim_set_hl(0, 'InactiveModeIndicator',
  {bg = "#444444", fg = "#dddddd", bold = true})

vim.api.nvim_set_hl(0, 'FiletypeIndicator',
  {link = 'NormalModeIndicator'})
vim.api.nvim_set_hl(0, 'InactiveFiletypeIndicator',
  {link = 'InactiveModeIndicator'})

-- The sidebar windows and information used for their titlebars. The windows
-- maintain the top to bottom order of this table.
local sidebar_infos = {
  {filetype = 'undotree', icon = '', filename_replacement = 'Undo Tree'},
  {filetype = 'NvimTree', icon = '', filename_replacement = 'File Tree'},
}

-- Constructs the left side of window title bars
local function title_bar_left(winid, bufid, sidebar_info)
  local bar_config = {}
  -- Insert the mode indicator.
  if winid == vim.api.nvim_get_current_win() then
    local mode = vim.api.nvim_get_mode()['mode']
    if mode == '\22' then mode = 'V' end
    mode = string.sub(string.upper(mode), 1, 1)
    local mode_elements = {
      ['N'] = {' N ', group = 'NormalModeIndicator'},
      ['I'] = {' I ', group = 'InsertModeIndicator'},
      ['V'] = {' V ', group = 'VisualModeIndicator'},
    }
    local mode_element = mode_elements[mode]
    if mode_element ~= nil then
      table.insert(bar_config, mode_element)
    else
      table.insert(bar_config, mode_elements['N'])
    end
  else
    table.insert(bar_config, {'   ', group = 'InactiveModeIndicator'})
  end

  if sidebar_info == nil then
    -- Initialize git status information.
    local statuses = {
      {type = 'added',   symbol = '+', hl_group_substr = 'Add'},
      {type = 'changed', symbol = '~', hl_group_substr = 'Change'},
      {type = 'removed', symbol = '-', hl_group_substr = 'Delete'},
    }
    local status_dict = vim.b[bufid].gitsigns_status_dict
    local git_config = {}
    if status_dict ~= nil then
      for _, status in ipairs(statuses) do
        local count = tonumber(status_dict[status.type])
        if count ~= nil and count > 0 then
          local text = status.symbol .. count
          local hl_group = 'GitSigns' .. status.hl_group_substr .. 'Nr'
          table.insert(git_config, {text, group = hl_group})
        end
      end
    end

    -- Initialize diagnostic information.
    local diagnostics = {
      {type = 'Error', symbol = ''},
      {type = 'Warn',  symbol = ''},
      {type = 'Info',  symbol = ''},
      {type = 'Hint',  symbol = ''},
    }
    local diagnostic_config = {}
    for _, diagnostic in ipairs(diagnostics) do
      local type_number = vim.diagnostic.severity[string.upper(diagnostic.type)]
      local count = #vim.diagnostic.get(bufid, {severity = type_number})
      if count > 0 then
        local text = diagnostic.symbol .. count
        local hl_group = 'Diagnostic' .. diagnostic.type
        table.insert(diagnostic_config, {text, group = hl_group})
      end
    end

    -- Insert git and diagnostic information if present or a single separator if
    -- not present.
    if #git_config > 0 then
      table.insert(bar_config, {' ', git_config, ' '})
      table.insert(bar_config, '|')
    end
    if #diagnostic_config > 0 then
      table.insert(bar_config, {' ', diagnostic_config, ' '})
      table.insert(bar_config, '|')
    end
    if #git_config == 0 and #diagnostic_config == 0 then
      table.insert(bar_config, '|')
    end
  end
  return bar_config
end

-- Constructs the right side of window title bars
local devicons = require('nvim-web-devicons')
local function title_bar_right(winid, bufid, sidebar_info)
  local bar_config = {}
  local icon = ''
  local filename = ''
  if sidebar_info == nil then
    -- Insert an icon for the file format.
    local format_symbols = {
      unix = '󰻀',
      dos = '',
      mac = '',
    }
    local fileformat = vim.bo.fileformat
    table.insert(bar_config, '|')
    table.insert(bar_config, {' ', {format_symbols[fileformat]}, ' '})
    table.insert(bar_config, '|')

    -- Insert line and cursor position information.
    local cursor_pos = vim.api.nvim_win_get_cursor(winid)[1]
    local line_count = vim.api.nvim_buf_line_count(bufid)
    local percentage = 100;
    if line_count > 0 then
      percentage = math.floor(100 * (cursor_pos/line_count))
    end
    table.insert(bar_config, {' ', percentage .. '%' .. line_count, ' '})
    table.insert(bar_config, '|')

    -- Get the icon and filename relative to the current working directory.
    local full_filename = vim.api.nvim_buf_get_name(bufid)
    local file_tail = vim.fn.fnamemodify(full_filename, ':t')
    local file_ext = vim.fn.fnamemodify(full_filename, ':e')
    icon = devicons.get_icon(file_tail, file_ext, {default = true})
    filename = vim.fn.fnamemodify(full_filename, ':.')
  else
    icon = sidebar_info.icon
    filename = sidebar_info.filename_replacement
  end

  -- Insert the filename and file type icon.
  table.insert(bar_config, {' ', {filename, gui = 'italic'}, ' '})
  local icon_text = ' ' .. icon .. ' '
  if winid == vim.api.nvim_get_current_win() then
    table.insert(bar_config, {icon_text, group = 'FiletypeIndicator'})
  else
    table.insert(bar_config, {icon_text, group = 'InactiveFiletypeIndicator'})
  end
  return bar_config
end

-- Get the character length of the bar table.
local function bar_string_length(bar_table)
  local length = 0
  for _, element in ipairs(bar_table) do
    local type = type(element)
    if type == "table" then
      length = length + bar_string_length(element)
    elseif type == "string" then
      length = length + vim.str_utfindex(element)
    end
  end
  return length
end

-- Enusre that the titlebar spans the width of the window. When the titlebar is
-- too small, spaces are inserted between its left and right sides. When it's
-- too large, leading characters are trimmed from the relative filename.
local function bar_fit_to_window(bar, winid)
  local bar_length = bar_string_length(bar)
  local window_width = vim.api.nvim_win_get_width(winid)
  if bar_length <= window_width then
    local fill_amount = window_width - bar_length
    local fill = string.rep(' ', fill_amount)
    table.insert(bar, 2, fill)
  else
    local prefix_replacement = ''
    local remove_count = (bar_length - window_width) + 1
    local right_config = bar[#bar]
    local filename_element = right_config[#right_config - 1][2]
    local trimmed = string.sub(filename_element[1], remove_count + 1)
    filename_element[1] = prefix_replacement .. trimmed
  end
  return bar
end

-- Configure window title bars.
local incline = require('incline')
incline.setup({
  render = function(props)
    local filetype = vim.bo[props.buf].filetype
    local sidebar_info = nil
    for _, info in ipairs(sidebar_infos) do
      if filetype == info.filetype then
        sidebar_info = info
        break
      end
    end

    local bar = {}
    table.insert(bar, title_bar_left(props.win, props.buf, sidebar_info))
    table.insert(bar, title_bar_right(props.win, props.buf, sidebar_info))
    return bar_fit_to_window(bar, props.win)
  end,

  window = {
    placement = {
      vertical = 'top',
      horizontal = 'right',
    },
    margin = {
      horizontal = 0,
      vertical = 0,
    },
    padding = 0,
    winhighlight = {
      active = {
        Normal = 'WinBar',
      },
      inactive = {
        Normal = 'WinBarNC',
      },
    },
    overlap = {
      borders = true,
      winbar = true,
      tabline = false,
      statusline = false,
    },
  },
  ignore = {
    unlisted_buffers = false,
    filetypes = {},
    wintypes = {},
    buftypes = {},
  },
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

-- File browser configuration
-- Disable netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- File browser toggle
local treeApi = require("nvim-tree.api")
vim.keymap.set("n", "<leader>E", function() treeApi.tree.toggle() end)
vim.keymap.set("n", "<leader>e", function() treeApi.tree.open() end)

-- File browser keybinds
local function nvim_tree_on_attach(bufnr)
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end
  vim.keymap.set("n", "?", treeApi.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "s", treeApi.tree.reload, opts("Refresh"))
  vim.keymap.set("n", "+", function()
    treeApi.tree.change_root_to_node()
    vim.cmd('cd ' .. vim.fn.getcwd())
  end, opts("Down"))
  vim.keymap.set("n", "-", function()
    treeApi.tree.change_root_to_parent()
    vim.cmd('cd ' .. vim.fn.getcwd())
  end, opts("Up"))
  vim.keymap.set("n", "*", treeApi.tree.collapse_all, opts("Collapse"))
  vim.keymap.set("n", "J", treeApi.node.navigate.sibling.next,
    opts("Next Sibling"))
  vim.keymap.set("n", "K", treeApi.node.navigate.sibling.prev,
    opts("Prev Sibling"))
  vim.keymap.set("n", "<2-LeftMouse>", treeApi.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<cr>", treeApi.node.open.edit, opts("Open"))
  vim.keymap.set("n", "o", treeApi.node.open.edit, opts("Open"))
  vim.keymap.set("n", "O", treeApi.node.open.no_window_picker, opts("Open"))
  vim.keymap.set("n", "a", treeApi.fs.create, opts("Add"))
  vim.keymap.set("n", "d", treeApi.fs.remove, opts("Delete"))
  vim.keymap.set("n", "r", treeApi.fs.rename, opts("Rename"))
  vim.keymap.set("n", "c", treeApi.fs.copy.node, opts("Copy"))
  vim.keymap.set("n", "p", treeApi.fs.paste, opts("Paste"))
  vim.keymap.set("n", "b", treeApi.marks.toggle, opts("Bookmark"))
  vim.keymap.set("n", "M", treeApi.marks.bulk.move, opts("Move Bookmarked"))
  vim.keymap.set("n", "D", treeApi.marks.bulk.delete, opts("Delete Bookmarked"))
end

-- File browser settings
require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  view = {
    signcolumn = "no",
    width = sidebar_width,
  },
  sort = {
    sorter = "case_sensitive",
  },
  renderer = {
    symlink_destination = false,
    root_folder_label = ":~:s?$?",
    icons = {
      git_placement = "after",
      modified_placement = "after",
      hidden_placement = "after",
      diagnostics_placement = "after",
      bookmarks_placement = "after",
      glyphs = {
        folder = {
          arrow_closed = "",
          arrow_open = "",
        }
      },
    },
    indent_markers = {
      enable = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "├",
        bottom = "─",
        none = " ",
      },
    },
  },
  filters = {
    dotfiles = false,
  },
})

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

-- Configure options for lsps.
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

vim.lsp.config['clangd'] = {
  filetypes = {'cpp', 'c'},
  root_markers = {"compile_commands.json", ".git"},
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        }
      },
    },
  },
  cmd = {
    "clangd",
    "--enable-config",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--header-insertion-decorators=false",
    "--completion-style=detailed",
  },
}
vim.lsp.enable('clangd')

-- Go to definition
vim.keymap.set('n', 'gd', '<c-]>')

-- Prevent indentation changes after typing ':'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c" },
  callback = function()
    vim.opt_local.cinkeys:remove(":")
  end,
})

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

-- Configure Autocomplete.
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
    }
  },
  mapping = cmp.mapping.preset.insert({
    ['<down>'] = cmp.mapping.select_next_item(
      {behavior = cmp.SelectBehavior.Select}),
    ['<up>'] = cmp.mapping.select_prev_item(
      {behavior = cmp.SelectBehavior.Select}),
    ['<tab>'] = cmp.mapping.confirm({select = true}),
  }),
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
  }),
})

-- Toggle autocomplete suggestions.
local cmp_enabled = true
vim.keymap.set({'n', 'i', 's', 'c'}, '<c-tab>', function()
  cmp_enabled = not cmp_enabled
  cmp.setup({enabled = cmp_enabled})
  if not cmp_enabled and cmp.visible() then
    cmp.close()
  elseif cmp_enabled and not cmp.visible() then
    cmp.complete()
  end
end)

-- Give all sidebar windows the same height and resize other windows.
local function format_sidebar()
  -- Find all active sidebar windows.
  local active_windows = {}
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    local window_filetype = vim.api.nvim_buf_get_option(bufid, "filetype")
    for _, sidebar_info in pairs(sidebar_infos) do
      if window_filetype == sidebar_info.filetype then
        active_windows[#active_windows + 1] = winid
      end
    end
  end
  -- Give each sidebar window the same height.
  -- -1 accounts for the command line.
  local totalHeight = vim.opt.lines:get() - 1
  local height = math.floor(totalHeight / #active_windows)
  for _, winid in ipairs(active_windows) do
    vim.api.nvim_win_set_config(winid, {height = height})
  end
  vim.cmd('wincmd =')
end

-- Valid windows at the top of the vim window receive a winbar while the
-- winbars from all other windows are removed.
local function ensure_winbar(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local filetype = vim.bo[bufid].filetype
  if filetype == 'incline' then
    return
  end
  local position = vim.api.nvim_win_get_position(winid)
  if position[1] == 0 then
    vim.api.nvim_set_option_value("winbar", ' ', {win = winid})
  else
    vim.api.nvim_set_option_value("winbar", '', {win = winid})
  end
end

-- Ensure winbars for all windows.
local function ensure_all_winbars()
  local windows = vim.api.nvim_list_wins()
  for _, winid in ipairs(windows) do
    ensure_winbar(winid)
  end
end

-- Winbars must be re-ensured after window resizing. When a vertical split is
-- created, this ensures that the top window receives a winbar and the bottom
-- one does not.
vim.api.nvim_create_autocmd('WinResized', {
  pattern = '*',
  callback = function()
    local affected_windows = vim.v.event.windows
    for _, winid in pairs(affected_windows) do
      ensure_winbar(winid)
    end
  end,
})

-- Place sidebar windows in the correct position with the correct height.
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    -- Ensure that the new window is one that belongs on the sidebar.
    local bufid = vim.api.nvim_win_get_buf(0)
    local new_filetype = vim.api.nvim_buf_get_option(bufid, 'filetype')
    local new_sidebar_window_pos = -1
    for i, sidebar_info, _ in ipairs(sidebar_infos) do
      if new_filetype == sidebar_info.filetype then
        new_sidebar_window_pos = i
        break
      end
    end
    if new_sidebar_window_pos == -1 then
      ensure_winbar(vim.api.nvim_get_current_win())
      return
    end

    -- Find the sidebar windows that should be directly above and directly below
    -- the new sidebar window.
    local above_sidebar_winid = -1
    local below_sidebar_winid = -1
    for i=new_sidebar_window_pos - 1, 1, -1 do
      above_sidebar_winid = get_filetype_win(sidebar_infos[i].filetype)
      if above_sidebar_winid ~= -1 then
        break
      end
    end
    for i=new_sidebar_window_pos + 1, #sidebar_infos, 1 do
      below_sidebar_winid = get_filetype_win(sidebar_infos[i].filetype)
      if below_sidebar_winid ~= -1 then
        break
      end
    end

    -- Place the new sidebar window in the correct position.
    if above_sidebar_winid ~= -1 then
      vim.api.nvim_win_set_config(0, {
        split = 'below',
        win = above_sidebar_winid,
        width = sidebar_width,
      })
    elseif below_sidebar_winid ~= -1 then
      vim.api.nvim_win_set_config(0, {
        split = 'above',
        win = below_sidebar_winid,
        width = sidebar_width,
      })
    end
    format_sidebar()
    ensure_all_winbars()
  end
})

-- The undotree window does not trigger the BufWinEnter event, thus we are
-- forced to configure its position and size here separately.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'undotree',
  callback = function()
    -- Place the undotree in the correct sidebar position if a sidebar window
    -- exists.
    for i = 2, #sidebar_infos, 1 do
      local winid = get_filetype_win(sidebar_infos[i].filetype)
      if winid ~= -1 then
        vim.api.nvim_win_set_config(0, {
          split = 'above',
          win = winid,
          height = 1,
        })
        break
      end
    end
    -- Ensure the undotree uses the correct width.
    local current_win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value('winfixwidth', true, {win = current_win_id})
    vim.api.nvim_win_set_width(current_win_id, sidebar_width)
    vim.cmd('setlocal winbar=')
    format_sidebar()
    ensure_all_winbars()
  end,
})

