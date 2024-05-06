local wezterm = require "wezterm"
local platform = require('utils.platform')()

local options = {
   default_prog = {},
   launch_menu = {},
}

local ssh_config_file = wezterm.home_dir .. "/.config/wezterm/ssh_config"

if platform.is_win then
   ssh_config_file = wezterm.home_dir .. "\\.config\\wezterm\\ssh_config"
   options.default_prog = { 'powershell' }
   options.launch_menu = {
      { label = 'PowerShell Core', args = { 'pwsh' } },
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd' } },
      { label = 'Nushell', args = { 'nu' } },
      {
         label = 'Git Bash',
         args = { 'D:\\Program Files\\Git\\usr\\bin\\bash.exe' },
      },
   }
elseif platform.is_mac then
   options.default_prog = { '/opt/bin/fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { '/opt/bin/fish', '-l' } },
      { label = 'Nushell', args = { '/opt/bin/nu', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { 'fish', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
end

function split(str)
    local pattern = "%S+"
    local matches = {}
    for word in str:gmatch(pattern) do
        table.insert(matches, word)
    end
    return matches
end

local f = io.open(ssh_config_file)
local ssh_cmd = {"ssh"}
if f then
    local line = f:read("*l")
    while line do
        if line:find("Host ") == 1 then
            local host = line:gsub("^Host ", "")
            local args = {}
            for i, v in pairs(ssh_cmd) do
                args[i] = v
            end
            local tab = split(host)
            args[#args+1] = tab[2]
            table.insert(
            options.launch_menu,
            {
                label = "ssh - " .. host,
                args = args,
            }
            )
        end
        line = f:read("*l")
    end
    f:close()
end

return options
