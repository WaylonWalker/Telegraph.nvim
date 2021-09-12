--  _____    _                            _     
-- |_   _|__| | ___  __ _ _ __ __ _ _ __ | |__  
--   | |/ _ \ |/ _ \/ _` | '__/ _` | '_ \| '_ \ 
--   | |  __/ |  __/ (_| | | | (_| | |_) | | | |
--   |_|\___|_|\___|\__, |_|  \__,_| .__/|_| |_|
--                  |___/          |_|.nvim
-- Waylon Walker
-- 

local M = {}
local api = vim.api
local Path = require("plenary.path")

M.get_session_name = function()
    return io.popen("tmux display-message -p '#S'"):read()
end

default_config = {
    cmd = "",
    session_name = '{current_session_name}-{filename}',
    how = 'term'
}

TelegraphConfig = TelegraphConfig or default_config

-- vendored from plenary
sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

-- vendored from plenary
local _get_parent = (function()
  local formatted = string.format("^(.+)%s[^%s]+", sep, sep)
  return function(abs_path)
    return abs_path:match(formatted)
  end
end)()


M.telegraph= function(config)
    local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) or ''
    local filename = filepath:match("^.+/(.+)$")
    local current_session_name = M.get_session_name()
    config = config or {}
    cmd = config.cmd or TelegraphConfig.cmd or default_config.cmd
    how = config.how or TelegraphConfig.how or default_config.how
    local session_name = config.session_name or TelegraphConfig.session_name or default_config.session_name
    
    local format_command = function(command_str)
        return (command_str
            :gsub("{filepath}", filepath)
            :gsub("{parent}", _get_parent(filepath) or '')
            :gsub("{filename}", filename)
            :gsub("{current_session_name}", current_session_name)
            :gsub("{cword}", vim.fn.expand"<cword>")
            :gsub("{cWORD}", vim.fn.expand"<cWORD>")
            :gsub("{cwd}", vim.fn.getcwd())
            :gsub("{cline}", vim.api.nvim_get_current_line())
            )
    end

    
    local command = format_command(cmd)
    local session_name = format_command(session_name):gsub("%.", '_')

    if how == 'tmux' then
        -- print(session_name)
        os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "' .. command .. '"')
        os.execute('tmux switch-client -t "' .. session_name .. '"')
        -- print('tmux switch-client -t "' .. session_name .. '"')
    elseif how == 'tmux-popup-session' or how == 'tmux_popup_session' then
        os.execute('tmux new-session -Ad -s "' .. session_name .. '" -c "#{pane_current_path}" "' .. command .. '"')
        os.execute('tmux display-popup "tmux new-session -A -s ' .. session_name .. '"')
    elseif how == 'tmux_popup' or how == 'tmux-popup' then
        os.execute('tmux display-popup  -E ' .. command )
    else
        vim.cmd('term ' .. command)
        vim.cmd('startinsert')
    end


end

vim.cmd("command! -nargs=1 Telegraph lua require'telegraph'.telegraph({cmd=<f-args>})")

M.setup = function(config)
    if not config then
        local config = default_config
    end
    TelegraphConfig = config
end

return M
