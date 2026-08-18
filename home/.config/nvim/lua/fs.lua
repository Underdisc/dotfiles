-- Disable netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Filesystem Exploration and Minor Editing
vim.pack.add({
  'https://github.com/mikavilpas/yazi.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/snacks.nvim',
})
local yazi = require('yazi')
yazi.setup({
  floating_window_scaling_factor = 0.9,
  yazi_floating_window_border = 'single',
  hooks = {
    yazi_opened = function(preselected_path, bufid, config)
      vim.api.nvim_set_option_value('winbar', '', { win = winid })
    end,
  },
  keymaps = {
    change_working_directory = '\\',
  },
})

-- Filename Editing
vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})
local oil = require('oil')
oil.setup({
  default_file_explorer = true,
  columns = {},
  buf_options = {
    buflisted = true,
  },
  view_options = {
    show_hidden = true,
    natural_order = false,
  },
})

-- Quick File (and more) Opening
vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
})
require('telescope').setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.9,
      height = 0.9,
    },
    mappings = {
      i = {
        ['<esc>'] = require('telescope.actions').close,
      },
    },
    file_ignore_patterns = {
      '.git/',
    },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  },
})

local fs = {}

local telescope_builtin = require('telescope.builtin')
function fs.telescope_file()
  telescope_builtin.find_files({ hidden = true, no_ignore = true })
end
function fs.telescope_grep() telescope_builtin.live_grep() end
function fs.telescope_buffer() telescope_builtin.buffers() end
function fs.telescope_help() telescope_builtin.help_tags() end

return fs
