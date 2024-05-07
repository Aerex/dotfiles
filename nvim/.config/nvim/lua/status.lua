local M = {}
M.discord = function ()
  require("presence").setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = 'Vim  with vigor', -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})

end
M.galaxy = function ()
  local gl = require('galaxyline')
  local galaxyline_colours = require("galaxyline.theme").default
  local devicons = require('nvim-web-devicons')
  local u = require('utils').u
  local gls = gl.section
  gl.short_line_list = {
    'fugitive',
    'fugitiveblame',
    'dapui-watches',
    'dapui-stacks',
    'dapui-scopes',
    'dap-repl'
  }
  local icons = {
    modified = '',
    readonly = ''
  }
  --local icons = {
  --    locker = u 'f023',
  --    unsaved = u 'f693',
  --    dos = u 'e70f',
  --    unix = u 'f17c',
  --    mac = u 'f179',
  --    lsp_warn = u 'f071',
  --    lsp_error = u 'f46e'
  --}


  local colors = {
    bg = '#282c34',
    line_bg = '#353644',
    fg = '#8FBCBB',
    fg_green = '#65a380',

    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67'
}

local remote_ip = function()
  if not vim.env.SSH_CLIENT then
    return ''
  end
  local ssh_client_info = vim.split(vim.env.SSH_CLIENT, ' ')
    if #ssh_client_info > 0 then
      return ssh_client_info[1]
    end
    return ''
end
local get_diagnostic_info = function()
  if #vim.lsp.buf_get_clients() > 0 then
    local lspclient = require('galaxyline.provider_lsp')
    local status = lspclient.get_lsp_client("")
    --local status = require'lsp-status'.status()
    -- NOTE: Do not print status if it contains file issue warning
    if string.find(status, 'github.com') then
      return ''
    end
    return status
  end
  return ''
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end


local has_file_type = function()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    return true
end

local get_fcitx_status = function()
  return  ''
  -- FIXME(me): Need to check for 'Not get reply' if so print ''
  --if vim.fn.executable('fcitx-remote') == 1 then
  --  local status = vim.split(vim.fn.system('fcitx-remote'), '\n')[1]
  --  if  status ~= 'Not get reply' then
  --    return ''
  --  end
  --  return tonumber(vim.fn.system('fcitx-remote')) > 1 and ' ' or ''
  --else
  --  return ''
  --end
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local get_file_name = function()
  local fname = vim.fn.expand('%:p')
  local truncated_parts = {}
  if vim.startswith(fname, vim.env.HOME) then
    fname = vim.fn.substitute(fname, vim.env.HOME, "~", "")
  end
  local parts = vim.split(fname, '/')
  local sname = ""
  if #parts > 4 then
    sname = vim.fn.join(vim.list_slice(parts, #parts-2, #parts), "/")
    sname = parts[1] .. "/../" .. sname
    elseif #parts == 3 then
      sname = vim.fn.expand('%:t')
    else
      sname = fname
  end

  if not #sname then return '' end
  return ' ' .. sname .. ' '
end

local get_file_state_icon = function()
  local file_icon = ''
  if vim.bo.readonly == true then
    file_icon = icons.readonly
  end
  if vim.bo.modifiable and vim.bo.modified then
    file_icon = icons.modified
  end

  return file_icon .. ' '
end

LSPStatus = get_diagnostic_info
TrailingWhiteSpace = trailing_whitespace
RemoteIP = remote_ip
FCITXStatus = get_fcitx_status

gls.left[1] = {
  FirstElement = {
    provider = function() return ' ' end,
    highlight = {colors.blue,colors.line_bg}
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local modes = {
        -- Normal
        n = { "Normal", galaxyline_colours.violet },
        no = { "Operator Pending", galaxyline_colours.violet },
        -- Insert
        i = { "Insert", galaxyline_colours.yellow },
        -- Visual
        v = { "Visual", galaxyline_colours.magenta },
        V = { "Visual Line", galaxyline_colours.magenta },
        [""] = { "Visual Block", galaxyline_colours.magenta },
        -- Select
        s = { "Select", galaxyline_colours.blue },
        S = { "Select Line", galaxyline_colours.blue },
        [""] = { "Select Block", galaxyline_colours.blue },
        -- Replace
        R = { "Replace", galaxyline_colours.red },
        Rv = { "Virtual Replace", galaxyline_colours.red },
          -- Exec
          c = { "Command", galaxyline_colours.orange },
          cv = { "Vim Ex", galaxyline_colours.green },
          ce = { "Normal Ex", galaxyline_colours.green },
          r = { "Hit-Enter Prompt", galaxyline_colours.cyan },
          rm = { "More Prommpt", galaxyline_colours.cyan },
          ["r?"] = { "Confirm Query", galaxyline_colours.green },
          ["!"] = { "Shell", galaxyline_colours.orange },
          t = { "Terminal", galaxyline_colours.green },
        }
      -- auto change color according the vim mode
      local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          V= 'VISUAL',
          [''] = 'VISUAL',
          v ='VISUAL',
          c  = 'COMMAND-LINE',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R  = 'REPLACE',
          Rv = 'VIRTUAL',
          s  = 'SELECT',
          S  = 'SELECT',
          ['r']  = 'HIT-ENTER',
          [''] = 'SELECT',
          t  = 'TERMINAL',
          ['!']  = 'SHELL',
      }
      local mode_color = {
          n = colors.green,
          i = colors.blue,
          v=colors.magenta,
          [''] = colors.blue,
          V=colors.blue,
          c = colors.red,
          no = colors.magenta,
          s = colors.orange,
          S=colors.orange,
          [''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
          cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
          ['!']  = colors.green,t = colors.green,
          c  = colors.purple,
          ['r?'] = colors.red,
          ['r']  = colors.red,
          rm = colors.red,
          R  = colors.yellow,
          Rv = colors.magenta,
      }
      local vim_mode = vim.fn.mode()
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode])
      return alias[vim_mode] .. '   '
    end,
    highlight = {colors.red,colors.line_bg,'bold'},
  },
}
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
}
gls.left[4] = {
  FileStateIcon = {
    provider = get_file_state_icon,
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}

gls.left[5] = {
  FileName = {
    provider = get_file_name,
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}

gls.left[6] = {
  BlankSpace = {
    provider = function() return ' ' end,
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}


gls.left[7] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.orange,colors.line_bg},
  }
}

-- TODO(me): This is too slow with big repos or using a worktree with many nested directories
-- Need to make custom provider to handle this better
--gls.left[8] = {
--  GitBranch = {
--    provider = 'GitBranch',
--    condition = buffer_not_empty,
--    highlight = {colors.fg,colors.line_bg,'bold'},
--  }
--}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left[9] = {
  BlankSpace = {
    provider = function() return ' ' end,
    condition = checkwidth,
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}
gls.left[10] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.green,colors.line_bg},
  }
}
gls.left[11] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[12] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.red,colors.line_bg},
  }
}
gls.left[13] = {
  LeftEnd = {
    provider = function() return '' end,
    separator = '',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.line_bg,colors.line_bg}
  }
}

gls.left[14] = {
    TrailingWhiteSpace = {
     provider = TrailingWhiteSpace,
     icon = '  ',
     highlight = {colors.yellow,colors.bg},
    }
}

gls.left[15] = {
  LSPStatus = {
    provider = LSPStatus,
    highlight = {colors.yellow,colors.bg},
    icon = ' λ ',
  }
}

gls.right[1] = {
  RemoteIP = {
    provider = RemoteIP,
    highlight = {colors.yellow,colors.bg},
  }
}
gls.right[2] = {
  FCITXStatus = {
    provider = FCITXStatus,
    highlight = {colors.yellow,colors.bg},
  }
}
gls.right[3]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg,'bold'},
  }
}
gls.right[4] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg},
  },
}
gls.right[5] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.line_bg,colors.line_bg},
    highlight = {colors.cyan,colors.darkblue,'bold'},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    condition = has_file_type,
    separator_highlight = {colors.fg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.fg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}

end

return M
