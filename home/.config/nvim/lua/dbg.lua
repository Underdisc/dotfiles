local dbg = {}

function dbg.log(object, opts)
  local text = ''
  if opts ~= nil and opts.date == true then
    text = text .. os.date('%y-%m-%d;%H:%M:%S') .. '\n'
  end
  text = text .. vim.inspect(object)

  if opts ~= nil and opts.file ~= nil then
    local path = vim.fn.expand(opts.file)
    local file = io.open(path, 'a')
    if file then
      file:write(text .. '\n')
      file:close()
    end
  else
    print(text)
  end
end

return dbg

