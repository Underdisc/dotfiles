-- Prevent Window Closure on Buffer Removal
vim.pack.add({ 'https://github.com/moll/vim-bbye' })

-- Navigate Buffers as a Vertical List.
vim.opt.rtp:append('~/.config/nvim/ext/vuffers.nvim')
local sidebar = require('sidebar')
local vuffers = require('vuffers')
vuffers.setup({
  wrap = true,
  exclude = {
    filetypes = { 'vuffers', 'undotree' },
  },
  keymaps = {
    use_default = true,
    view = {
      open = '<enter>',
      delete = '<c-x>',
      move_down = '<c-5>',
      move_up = '<c-6>',
    },
  },
  view = {
    modified_icon = '',
    highlight_entire_active_line = true,
    create_buffer_text = function(info)
      return vim.fn.fnamemodify(info.path, ':.')
    end,
    trim_buffer_text = true,
    trim_icon = '',
    window = {
      width = sidebar.width,
    },
  },
})

-- Display help files in the buffer window.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function() vim.bo.buflisted = true end,
})

-- Regenerate the buffer lines on a global cwd change.
vim.api.nvim_create_autocmd('DirChanged', {
  pattern = 'global',
  callback = function() vuffers.reset_buffers() end,
})
