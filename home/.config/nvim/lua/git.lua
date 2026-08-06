-- Git Interactions and Gutter Coloring
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
local gitsigns = require('gitsigns')
gitsigns.setup({
  signcolumn = false,
  numhl = true,
})

local git = {}

function git.toggle_hunk()
  local mode = string.lower(vim.fn.mode())
  if mode == 'n' then
    gitsigns.stage_hunk()
  elseif mode == 'v' or mode == '\22' then
    local range = { vim.fn.line('v'), vim.fn.line('.') }
    gitsigns.stage_hunk(range)
  end
end

function git.toggle_inline_diff()
  gitsigns.toggle_deleted()
  gitsigns.toggle_word_diff()
end

-- Set git commit message view colors.
-- Quickly view the commit message for a line.
local git_log_ns = vim.api.nvim_create_namespace('GitLog')
function git.show_commit_message()
  -- Get the commit sha of the current line.
  local file = vim.fn.expand('%:p')
  local directory = vim.fn.expand('%:p:h')
  local line_number = vim.fn.line('.')
  local line_range = line_number .. ',' .. line_number
  local blame_cmd = { 'git', 'blame', '-L', line_range, '--porcelain', file }
  local result = vim.system(blame_cmd, { cwd = directory, text = true }):wait()
  local sha = vim.split(result.stdout, ' ')[1]

  -- Put the commit's log in a new buffer, but return if there is no log.
  local date_format = '--date=format:%y-%m-%d'
  local log_format = '--format=%h %ad %an%n%B'
  local log_cmd = { 'git', 'log', '-n 1', date_format, log_format, sha }
  result = vim.system(log_cmd, { cwd = directory, text = true }):wait()
  if result.stdout == '' then return end
  local buff_lines = vim.split(result.stdout, '\n')
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buff_lines)
  vim.bo[bufnr].modifiable = false

  -- Apply highlights to information shared amongst all logs.
  local sha_start = { 0, 0 }
  local sha_end = { 0, string.find(buff_lines[1], ' ') - 1 }
  local date_start = { 0, sha_end[2] + 1 }
  local date_end = { 0, string.find(buff_lines[1], ' ', date_start[2] + 1) - 1 }
  local author_start = { 0, date_end[2] + 1 }
  local author_end = { 0, #buff_lines[1] }
  local summary_start = { 1, 0 }
  local summary_end = { 1, #buff_lines[2] }
  vim.hl.range(bufnr, git_log_ns, 'GitSha', sha_start, sha_end)
  vim.hl.range(bufnr, git_log_ns, 'GitDate', date_start, date_end)
  vim.hl.range(bufnr, git_log_ns, 'GitAuthor', author_start, author_end)
  vim.hl.range(bufnr, git_log_ns, 'GitSummary', summary_start, summary_end)

  -- Open a popup window with the log buffer at the top of the current window.
  local current_window_width = vim.api.nvim_win_get_width(0)
  local padding = 5
  local max_width = 80
  local log_width = math.min(current_window_width - padding * 2, max_width)
  local winid = vim.api.nvim_open_win(bufnr, true, {
    border = 'single',
    relative = 'win',
    width = log_width,
    height = 10,
    row = 0,
    col = padding - 1,
  })
  vim.wo[winid].number = false
  vim.wo[winid].relativenumber = false

  -- Close the log window and delete the buffer if it loses focus.
  vim.api.nvim_create_autocmd('WinLeave', {
    once = true,
    callback = function()
      vim.api.nvim_win_close(winid, true)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end,
  })
end

return git
