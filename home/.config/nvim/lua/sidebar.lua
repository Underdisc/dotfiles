-- The sidebar windows and information used for their titlebars. The windows
-- maintain the top to bottom order of this table.
local sidebar = {}

sidebar.width = 30
sidebar.infos = {
  {
    filetype = 'undotree',
    icon = '',
    filename_replacement = 'Undo Tree',
  },
  {
    filetype = 'vuffers',
    icon = '',
    filename_replacement = 'Buffers',
  },
}

local sidebar_winids = {}
for _, info in ipairs(sidebar.infos) do
  sidebar_winids[info.filetype] = -1
end

-- Give all sidebar windows the same height and resize other windows.
local function ensure_sidebar_heights()
  -- Find all active sidebar windows.
  local active_windows = {}
  for _, winid in pairs(sidebar_winids) do
    if winid ~= -1 then active_windows[#active_windows + 1] = winid end
  end
  -- Give each sidebar window the same height.
  -- -1 accounts for the command line.
  local totalHeight = vim.opt.lines:get() - 1
  local height = math.floor(totalHeight / #active_windows)
  for _, winid in ipairs(active_windows) do
    vim.api.nvim_win_set_config(winid, { height = height })
  end
end

local function ensure_sidebar_window_position(winid, sidebar_idx)
  -- Find the sidebar windows that should be directly above and directly below
  -- the new sidebar window.
  local above_sidebar_winid = -1
  for i = sidebar_idx - 1, 1, -1 do
    local ft = sidebar.infos[i].filetype
    above_sidebar_winid = sidebar_winids[ft]
    if above_sidebar_winid ~= -1 then break end
  end
  local below_sidebar_winid = -1
  for i = sidebar_idx + 1, #sidebar.infos, 1 do
    local ft = sidebar.infos[i].filetype
    below_sidebar_winid = sidebar_winids[ft]
    if below_sidebar_winid ~= -1 then break end
  end

  -- Place the new sidebar window in the correct position.
  if above_sidebar_winid ~= -1 then
    vim.api.nvim_win_set_config(winid, {
      split = 'below',
      win = above_sidebar_winid,
      width = sidebar.width,
    })
  elseif below_sidebar_winid ~= -1 then
    vim.api.nvim_win_set_config(winid, {
      split = 'above',
      win = below_sidebar_winid,
      width = sidebar.width,
    })
  end
end

local function handle_new_window()
  -- Determine whether the new window is a sidebar window.
  local winid = vim.api.nvim_get_current_win()
  local bufid = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
  local sidebar_idx = nil
  for i, sidebar_info, _ in ipairs(sidebar.infos) do
    if ft == sidebar_info.filetype then
      sidebar_idx = i
      break
    end
  end

  -- Apply window properties.
  if sidebar_idx ~= nil then
    sidebar_winids[ft] = winid
    vim.api.nvim_set_option_value('winfixwidth', true, { win = winid })
    vim.api.nvim_win_set_width(winid, sidebar.width)
    ensure_sidebar_window_position(winid, sidebar_idx)
    ensure_sidebar_heights()
    vim.cmd('wincmd =')
  end
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function() handle_new_window() end,
})

-- The undotree window doesn't trigger the BufWinEnter event, thus forcing us to
-- handle its creation here.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'undotree',
  callback = function() handle_new_window() end,
})

-- Sidebar heights need to be adjusted if a sidebar window is closed.
vim.api.nvim_create_autocmd('WinClosed', {
  pattern = '*',
  callback = function()
    for ft, winid in pairs(sidebar_winids) do
      if winid ~= -1 and not vim.api.nvim_win_is_valid(winid) then
        sidebar_winids[ft] = -1
        ensure_sidebar_heights()
        break
      end
    end
  end,
})

return sidebar
