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

local buffer = {}

function buffer.toggle_or_open_specified_buffer()
  if vim.v.count == 0 then
    vuffers.toggle()
  else
    vuffers.go_to_buffer_by_line()
  end
end

function buffer.switch_buffer_down()
  vuffers.go_to_buffer_by_count({ direction = 'next' })
end

function buffer.switch_buffer_up()
  vuffers.go_to_buffer_by_count({ direction = 'prev' })
end

function buffer.move_buffer_down()
  vuffers.move_current_buffer_by_count({ direction = 'next' })
end

function buffer.move_buffer_up()
  vuffers.move_current_buffer_by_count({ direction = 'prev' })
end

return buffer
