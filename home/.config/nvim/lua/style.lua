-- Colorscheme
vim.pack.add({
  'https://github.com/rockyzhang24/arctic.nvim',
  'https://github.com/rktjmp/lush.nvim',
})
vim.cmd('colorscheme arctic')

-- Configure the character used for color columns
vim.pack.add({ 'https://github.com/lukas-reineke/virt-column.nvim' })
require('virt-column').setup({
  char = '▎',
  highlight = 'ColorColumn',
})
vim.api.nvim_set_hl(0, 'ColorColumn', { fg = '#888888' })

-- Create indent lines and give them custom colors
vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })
local ibl_color_groups = { 'ibl1', 'ibl2', 'ibl3', 'ibl4', 'ibl5' }
vim.api.nvim_set_hl(0, ibl_color_groups[1], { fg = '#888A8A' })
vim.api.nvim_set_hl(0, ibl_color_groups[2], { fg = '#318A2D' })
vim.api.nvim_set_hl(0, ibl_color_groups[3], { fg = '#2F8A5F' })
vim.api.nvim_set_hl(0, ibl_color_groups[4], { fg = '#32818A' })
vim.api.nvim_set_hl(0, ibl_color_groups[5], { fg = '#32498A' })
require('ibl').setup({
  indent = { highlight = ibl_color_groups },
  scope = { enabled = false },
})

-- Use the terminal's background color (allows transparency)
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1e1e1e', italic = true })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- Colors of other UI like elements
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#bbbbbb' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cccccc' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#555555' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#222222' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#555555' })

-- Highlight markdown code blocks.
vim.api.nvim_set_hl(0, '@markup.raw.block', { link = '@markup.link' })

vim.api.nvim_set_hl(
  0,
  'FlashMatch',
  { bg = '#0099cc', fg = '#000000', bold = true }
)
vim.api.nvim_set_hl(
  0,
  'FlashCurrent',
  { bg = '#0099cc', fg = '#000000', bold = true }
)
vim.api.nvim_set_hl(
  0,
  'FlashLabel',
  { bg = '#444444', fg = '#ffffff', bold = true }
)
vim.api.nvim_set_hl(0, 'FlashPromptIcon', { link = 'MsgArea' })
vim.api.nvim_set_hl(0, 'Search', { bg = '#444444' })
vim.api.nvim_set_hl(
  0,
  'CurSearch',
  { bg = '#bbbbbb', fg = '#000000', bold = true }
)

vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#222222', fg = '#cccccc' })
vim.api.nvim_set_hl(0, 'ModeMsg', { bg = '#222222', fg = '#cccccc' })

-- Highlight groups used for the cursor.
vim.api.nvim_set_hl(
  0,
  'NormalCursor',
  { bg = '#cccccc', fg = '#222222', bold = true }
)
vim.api.nvim_set_hl(
  0,
  'InsertCursor',
  { bg = '#44cc44', fg = '#222222', bold = true }
)
vim.api.nvim_set_hl(
  0,
  'VisualCursor',
  { bg = '#44cccc', fg = '#222222', bold = true }
)
vim.api.nvim_set_hl(
  0,
  'CommandCursor',
  { bg = '#cc4444', fg = '#222222', bold = true }
)
vim.api.nvim_set_hl(0, 'Visual', { bg = '#113366', bold = true })

-- Change cursor color depending on the mode.
vim.opt.guicursor = {
  'n:block-NormalCursor',
  'i:block-InsertCursor',
  'v:block-VisualCursor',
  'c:block-CommandCursor',
}

-- Highlight groups used in window titlebars.
vim.api.nvim_set_hl(0, 'FocusWinBar', { bg = '#444444', fg = '#eeeeee' })
vim.api.nvim_set_hl(0, 'UnfocusWinBar', { bg = '#222222', fg = '#cccccc' })
vim.api.nvim_set_hl(0, 'WinBar', { link = 'FocusWinBar' })
vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'UnfocusWinBar' })
vim.api.nvim_set_hl(0, 'NormalModeIndicator', { link = 'NormalCursor' })
vim.api.nvim_set_hl(0, 'InsertModeIndicator', { link = 'InsertCursor' })
vim.api.nvim_set_hl(0, 'VisualModeIndicator', { link = 'VisualCursor' })
vim.api.nvim_set_hl(0, 'CommandModeIndicator', { link = 'CommandCursor' })
vim.api.nvim_set_hl(
  0,
  'InactiveModeIndicator',
  { bg = '#444444', fg = '#dddddd', bold = true }
)

-- Highlight groups use for the tabline bar.
vim.api.nvim_set_hl(0, 'FocusTabLineFill', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'FocusTabLineUnsel', { bg = '#666666' })
vim.api.nvim_set_hl(0, 'FocusTabLineSel', { bg = '#cccccc', fg = '#000000' })
vim.api.nvim_set_hl(0, 'UnfocusTabLineFill', { bg = '#222222' })
vim.api.nvim_set_hl(0, 'UnfocusTabLineUnsel', { bg = '#333333' })
vim.api.nvim_set_hl(0, 'UnfocusTabLineSel', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'TabLineFill', { link = 'FocusTabLineFill' })
vim.api.nvim_set_hl(0, 'TabLineUnsel', { link = 'FocusTabLineUnsel' })
vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'FocusTabLineSel' })

-- Brighten or dim bars if nvim is or isn't focused.
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    vim.api.nvim_set_hl(0, 'WinBar', { link = 'FocusWinBar' })
    vim.api.nvim_set_hl(0, 'TabLineFill', { link = 'FocusTabLineFill' })
    vim.api.nvim_set_hl(0, 'TabLineUnsel', { link = 'FocusTabLineUnsel' })
    vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'FocusTabLineSel' })
  end,
})
vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    vim.api.nvim_set_hl(0, 'WinBar', { link = 'UnfocusWinBar' })
    vim.api.nvim_set_hl(0, 'TabLineFill', { link = 'UnfocusTabLineFill' })
    vim.api.nvim_set_hl(0, 'TabLineUnsel', { link = 'UnfocusTabLineUnsel' })
    vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'UnfocusTabLineSel' })
  end,
})

vim.api.nvim_set_hl(0, 'FiletypeIndicator', { link = 'NormalModeIndicator' })
vim.api.nvim_set_hl(
  0,
  'InactiveFiletypeIndicator',
  { link = 'InactiveModeIndicator' }
)

vim.api.nvim_set_hl(0, 'VuffersWindowBackground', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'VuffersIndex', { fg = '#999999' })
vim.api.nvim_set_hl(0, 'VuffersActiveBuffer', { link = 'CursorLine' })
vim.api.nvim_set_hl(0, 'VuffersModifiedIcon', { fg = '#77cccc' })
vim.api.nvim_set_hl(0, 'VuffersPinnedIcon', { fg = '#888888' })
vim.api.nvim_set_hl(0, 'VuffersActivePinnedIcon', { fg = '#77cccc' })

-- Git Colors
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = '#55d055' })
vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr', { fg = '#558855' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = '#ff4d4d' })
vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteNr', { fg = '#905555' })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = '#55ccee' })
vim.api.nvim_set_hl(0, 'GitSignsStagedChangeNr', { fg = '#558899' })
vim.api.nvim_set_hl(0, 'GitSha', { fg = '#00dddd' })
vim.api.nvim_set_hl(0, 'GitDate', { fg = '#ee44ff' })
vim.api.nvim_set_hl(0, 'GitAuthor', { fg = '#44ee44' })
vim.api.nvim_set_hl(0, 'GitSummary', { link = 'Title' })


