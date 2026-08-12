local function apply_highlights(his)
  for _, hi in ipairs(his) do
    vim.api.nvim_set_hl(0, hi[1], hi[2])
  end
end

-- Colorscheme
vim.pack.add({
  'https://github.com/rockyzhang24/arctic.nvim',
  'https://github.com/rktjmp/lush.nvim',
})
vim.cmd('colorscheme arctic')

-- Color Column
vim.pack.add({ 'https://github.com/lukas-reineke/virt-column.nvim' })
require('virt-column').setup({
  char = '▎',
  highlight = 'ColorColumn',
})

-- Colored Indentation Lines
vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })
local ibl = require('ibl')
local ibl_hooks = require('ibl.hooks')
local ibl_hi_groups = { 'ibl1', 'ibl2', 'ibl3', 'ibl4', 'ibl5' }
ibl_hooks.register(
  ibl_hooks.type.HIGHLIGHT_SETUP,
  function()
    apply_highlights({
      { ibl_hi_groups[1], { fg = '#888A8A' } },
      { ibl_hi_groups[2], { fg = '#318A2D' } },
      { ibl_hi_groups[3], { fg = '#2F8A5F' } },
      { ibl_hi_groups[4], { fg = '#32818A' } },
      { ibl_hi_groups[5], { fg = '#32498A' } },
    })
  end
)
ibl.setup({
  indent = { highlight = ibl_hi_groups },
  scope = { enabled = false },
})

-- Prevent unnecessary indentation lines from appearing in the undotree.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'undotree',
  callback = function() ibl.setup_buffer(0, { enabled = false }) end,
})

-- Mode Cursor Color Changes
vim.opt.guicursor = {
  'n:block-NormalCursor',
  'i:block-InsertCursor',
  'v:block-VisualCursor',
  'c:block-CommandCursor',
}

-- Winbar Focus Highlighting
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    apply_highlights({
      { 'WinBar', { link = 'FocusWinBar' } },
      { 'TabLineFill', { link = 'FocusTabLineFill' } },
      { 'TabLineUnsel', { link = 'FocusTabLineUnsel' } },
      { 'TabLineSel', { link = 'FocusTabLineSel' } },
    })
  end,
})
vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    apply_highlights({
      { 'WinBar', { link = 'UnfocusWinBar' } },
      { 'TabLineFill', { link = 'UnfocusTabLineFill' } },
      { 'TabLineUnsel', { link = 'UnfocusTabLineUnsel' } },
      { 'TabLineSel', { link = 'UnfocusTabLineSel' } },
    })
  end,
})

apply_highlights({
  -- Window Backgrounds
  { 'Normal', { bg = 'none' } },
  { 'NormalNC', { bg = 'none' } },
  { 'Pmenu', { bg = '#1e1e1e', italic = true } },
  { 'NormalFloat', { bg = 'none' } },

  -- Misc
  { 'WinSeparator', { fg = '#bbbbbb' } },
  { 'CursorLineNr', { fg = '#cccccc' } },
  { 'LineNr', { fg = '#555555' } },
  { 'CursorLine', { bg = '#222222' } },
  { 'NonText', { fg = '#555555' } },
  { 'Search', { bg = '#444444' } },
  { 'CurSearch', { bg = '#bbbbbb', fg = '#000000', bold = true } },
  { 'MsgArea', { bg = '#222222', fg = '#cccccc' } },
  { 'ModeMsg', { bg = '#222222', fg = '#cccccc' } },
  { 'ColorColumn', { fg = '#888888' } },
  { '@markup.raw.block', { link = '@markup.link' } },

  -- Cursor
  { 'NormalCursor', { bg = '#cccccc', fg = '#222222', bold = true } },
  { 'InsertCursor', { bg = '#44cc44', fg = '#222222', bold = true } },
  { 'VisualCursor', { bg = '#44cccc', fg = '#222222', bold = true } },
  { 'CommandCursor', { bg = '#cc4444', fg = '#222222', bold = true } },
  { 'Visual', { bg = '#113366', bold = true } },

  -- Winbars
  { 'FocusWinBar', { bg = '#444444', fg = '#eeeeee' } },
  { 'UnfocusWinBar', { bg = '#222222', fg = '#cccccc' } },
  { 'WinBar', { link = 'FocusWinBar' } },
  { 'WinBarNC', { link = 'UnfocusWinBar' } },
  { 'NormalModeIndicator', { link = 'NormalCursor' } },
  { 'InsertModeIndicator', { link = 'InsertCursor' } },
  { 'VisualModeIndicator', { link = 'VisualCursor' } },
  { 'CommandModeIndicator', { link = 'CommandCursor' } },
  { 'InactiveModeIndicator', { bg = '#444444', fg = '#dddddd', bold = true } },
  { 'FiletypeIndicator', { link = 'NormalModeIndicator' } },
  { 'InactiveFiletypeIndicator', { link = 'InactiveModeIndicator' } },

  -- Flash
  { 'FlashMatch', { bg = '#0099cc', fg = '#000000', bold = true } },
  { 'FlashCurrent', { bg = '#0099cc', fg = '#000000', bold = true } },
  { 'FlashLabel', { bg = '#444444', fg = '#ffffff', bold = true } },
  { 'FlashPromptIcon', { link = 'MsgArea' } },

  -- Tabbar
  { 'FocusTabLineFill', { bg = '#444444' } },
  { 'FocusTabLineUnsel', { bg = '#666666' } },
  { 'FocusTabLineSel', { bg = '#cccccc', fg = '#000000' } },
  { 'UnfocusTabLineFill', { bg = '#222222' } },
  { 'UnfocusTabLineUnsel', { bg = '#333333' } },
  { 'UnfocusTabLineSel', { bg = '#444444' } },
  { 'TabLineFill', { link = 'FocusTabLineFill' } },
  { 'TabLineUnsel', { link = 'FocusTabLineUnsel' } },
  { 'TabLineSel', { link = 'FocusTabLineSel' } },

  -- Vuffers
  { 'VuffersWindowBackground', { link = 'Normal' } },
  { 'VuffersIndex', { fg = '#999999' } },
  { 'VuffersActiveBuffer', { link = 'CursorLine' } },
  { 'VuffersModifiedIcon', { fg = '#77cccc' } },
  { 'VuffersPinnedIcon', { fg = '#888888' } },
  { 'VuffersActivePinnedIcon', { fg = '#77cccc' } },

  -- Git
  { 'GitSignsAddNr', { fg = '#55d055' } },
  { 'GitSignsStagedAddNr', { fg = '#558855' } },
  { 'GitSignsDeleteNr', { fg = '#ff4d4d' } },
  { 'GitSignsStagedDeleteNr', { fg = '#905555' } },
  { 'GitSignsChangeNr', { fg = '#55ccee' } },
  { 'GitSignsStagedChangeNr', { fg = '#558899' } },
  { 'GitSha', { fg = '#00dddd' } },
  { 'GitDate', { fg = '#ee44ff' } },
  { 'GitAuthor', { fg = '#44ee44' } },
  { 'GitSummary', { link = 'Title' } },

  -- Diagnostics
  { 'DiagnosticUnderlineError', { underdouble = true, update = true } },
  { 'DiagnosticUnderlineWarn', { underdouble = true, update = true } },
  { 'DiagnosticUnderlineInfo', { underdouble = true, update = true } },
  { 'DiagnosticUnderlineHint', { underdouble = true, update = true } },
})
