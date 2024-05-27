local M = {}
local metaTable = {}

local function openFile() 
  local envPath = vim.fn.expand("$HOME/.config/nvim/.env")
  local file, err = io.open(envPath, 'r')
  if file then

    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$")
        if line and line ~= "" then
            local key, value = line:match("([^=]+)=(.+)")
            if key and value then
              metaTable[key] = value
            end
        end
    end
    file:close()
  else
    print('Error opening dotenv:' .. err)
  end
end

local function getString(key)
  return metaTable[key]
end

openFile()

M.getString = getString
return M
