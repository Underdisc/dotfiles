vim.pack.add({ 'https://github.com/folke/flash.nvim' })
local flash = require('flash')
flash.setup({
  prompt = {
    prefix = { { '\\', 'FlashPromptIcon' } },
  },
  highlight = {
    backdrop = false,
  },
  modes = {
    char = {
      search = { wrap = true },
      highlight = { backdrop = false },
      keys = { 'f', 'F', 't', 'T', ';', [','] = ':' },
    },
  },
})

-- Undotree configuration
vim.pack.add({ 'https://github.com/mbbill/undotree' })
vim.g.undotree_DiffAutoOpen = 0
vim.g.undotree_SetFocusWhenToggle = true
vim.g.undotree_HelpLine = 0
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_SplitWidth = require('sidebar').width

-- Retrieve the id for a window displaying a buffer with the desired filetype.
local function get_filetype_win(filetype)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
    if ft == filetype then return winid end
  end
  return -1
end

local util = {}

function util.focus_undotree()
  -- Open the undotree window or focus it if it already exists.
  local undotree_winid = get_filetype_win('undotree')
  if undotree_winid == -1 then
    vim.cmd('UndotreeToggle')
  else
    vim.api.nvim_set_current_win(undotree_winid)
  end
end

return util
