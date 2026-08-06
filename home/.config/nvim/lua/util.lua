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

