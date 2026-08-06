-- Create the tabline string.
local function tabline()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLineUnsel#'
    end
    s = s .. '%' .. i .. 'T'
    s = s .. '  '
  end
  s = s .. '%#TabLineFill#%T'
  return s
end
_G.Tabline = tabline
vim.o.tabline = '%!v:lua.Tabline()'

local focused = true
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    focused = true
  end,
})

vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    focused = false
  end,
})


-- Constructs the left side of window title bars
local function title_bar_left(winid, bufid, window_info)
  local bar_config = {}
  -- Insert the mode indicator.
  if focused and winid == vim.api.nvim_get_current_win() then
    local mode = vim.api.nvim_get_mode()['mode']
    if mode == '\22' then mode = 'V' end
    mode = string.sub(string.upper(mode), 1, 1)
    local mode_elements = {
      ['N'] = { ' N ', group = 'NormalModeIndicator' },
      ['I'] = { ' I ', group = 'InsertModeIndicator' },
      ['V'] = { ' V ', group = 'VisualModeIndicator' },
    }
    local mode_element = mode_elements[mode]
    if mode_element ~= nil then
      table.insert(bar_config, mode_element)
    else
      table.insert(bar_config, mode_elements['N'])
    end
  else
    table.insert(bar_config, { '   ', group = 'InactiveModeIndicator' })
  end

  if window_info == nil then
    -- Initialize git status information.
    local statuses = {
      { type = 'added', symbol = '+', hl_group_substr = 'Add' },
      { type = 'changed', symbol = '~', hl_group_substr = 'Change' },
      { type = 'removed', symbol = '-', hl_group_substr = 'Delete' },
    }
    local status_dict = vim.b[bufid].gitsigns_status_dict
    local git_config = {}
    if status_dict ~= nil then
      for _, status in ipairs(statuses) do
        local count = tonumber(status_dict[status.type])
        if count ~= nil and count > 0 then
          local text = status.symbol .. count
          local hl_group = 'GitSigns' .. status.hl_group_substr .. 'Nr'
          table.insert(git_config, { text, group = hl_group })
        end
      end
    end

    -- Initialize diagnostic information.
    local diagnostics = {
      { type = 'Error', symbol = '' },
      { type = 'Warn', symbol = '' },
      { type = 'Info', symbol = '' },
      { type = 'Hint', symbol = '' },
    }
    local diagnostic_config = {}
    for _, diagnostic in ipairs(diagnostics) do
      local type_number = vim.diagnostic.severity[string.upper(diagnostic.type)]
      local count = #vim.diagnostic.get(bufid, { severity = type_number })
      if count > 0 then
        local text = diagnostic.symbol .. count
        local hl_group = 'Diagnostic' .. diagnostic.type
        table.insert(diagnostic_config, { text, group = hl_group })
      end
    end

    -- Insert git and diagnostic information if present or a single separator if
    -- not present.
    if #git_config > 0 then
      table.insert(bar_config, { ' ', git_config, ' ' })
      table.insert(bar_config, '|')
    end
    if #diagnostic_config > 0 then
      table.insert(bar_config, { ' ', diagnostic_config, ' ' })
      table.insert(bar_config, '|')
    end
    if #git_config == 0 and #diagnostic_config == 0 then
      table.insert(bar_config, '|')
    end
  end
  return bar_config
end

-- Constructs the right side of window title bars
vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' })
local devicons = require('nvim-web-devicons')
local function title_bar_right(winid, bufid, window_info)
  local bar_config = {}
  local icon = ''
  local filename = ''
  if window_info == nil then
    -- Insert line and cursor position information.
    local cursor_pos = vim.api.nvim_win_get_cursor(winid)
    local line_count = vim.api.nvim_buf_line_count(bufid)
    table.insert(bar_config, '|')
    table.insert(
      bar_config,
      { ' ', cursor_pos[2] .. ':' .. cursor_pos[1] .. ':' .. line_count, ' ' }
    )
    table.insert(bar_config, '|')

    -- Insert an icon for the file format.
    local format_symbols = {
      unix = '󰻀',
      dos = '',
      mac = '',
    }
    local fileformat = vim.bo.fileformat
    table.insert(bar_config, { ' ', { format_symbols[fileformat] }, ' ' })
    table.insert(bar_config, '|')

    -- Get the icon and filename relative to the current working directory.
    local full_filename = vim.api.nvim_buf_get_name(bufid)
    local file_tail = vim.fn.fnamemodify(full_filename, ':t')
    local file_ext = vim.fn.fnamemodify(full_filename, ':e')
    icon = devicons.get_icon(file_tail, file_ext, { default = true })
    filename = vim.fn.fnamemodify(full_filename, ':.')
  else
    icon = window_info.icon
    filename = window_info.filename_replacement
  end

  -- Insert the filename and file type icon.
  table.insert(bar_config, { ' ', { filename, gui = 'italic' }, ' ' })
  local icon_text = ' ' .. icon .. ' '
  if focused and winid == vim.api.nvim_get_current_win() then
    table.insert(bar_config, { icon_text, group = 'FiletypeIndicator' })
  else
    table.insert(bar_config, { icon_text, group = 'InactiveFiletypeIndicator' })
  end
  return bar_config
end

-- Get the character length of the bar table.
local function bar_string_length(bar_table)
  local length = 0
  for _, element in ipairs(bar_table) do
    local type = type(element)
    if type == 'table' then
      length = length + bar_string_length(element)
    elseif type == 'string' then
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

local window_infos = {
  {
    filetype = 'fugitiveblame',
    icon = '',
    filename_replacement = '',
  },
}

-- Valid windows at the top of the vim window receive a winbar while the
-- winbars from all other windows are removed.
local function ensure_winbar(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local filetype = vim.bo[bufid].filetype
  if filetype == 'incline' then return end
  local position = vim.api.nvim_win_get_position(winid)
  if position[1] == 0 then
    vim.api.nvim_set_option_value('winbar', ' ', { win = winid })
  else
    vim.api.nvim_set_option_value('winbar', '', { win = winid })
  end
end

-- Configure window title bars.
vim.pack.add({ 'https://github.com/b0o/incline.nvim' })
local incline = require('incline')
local sidebar = require('sidebar')
incline.setup({
  render = function(props)
    local filetype = vim.bo[props.buf].filetype
    local window_info = nil
    for _, info in ipairs(sidebar.infos) do
      if filetype == info.filetype then
        window_info = info
        break
      end
    end
    for _, info in ipairs(window_infos) do
      if filetype == info.filetype then
        window_info = info
        break
      end
    end

    local bar = {}
    table.insert(bar, title_bar_left(props.win, props.buf, window_info))
    table.insert(bar, title_bar_right(props.win, props.buf, window_info))
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

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    ensure_winbar(winid)
  end,
})

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

