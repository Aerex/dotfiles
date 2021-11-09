local gl = require('galaxyline')
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
    locker = u 'f023',
    unsaved = u 'f693',
    dos = u 'e70f',
    unix = u 'f17c',
    mac = u 'f179',
    lsp_warn = u 'f071',
    lsp_error = u 'f46e'
}


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
    blue = '#51afef';
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
    return require'lsp-status'.status()
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
  if vim.fn.executable('fcitx-remote') == 1 then
    return tonumber(vim.fn.system('fcitx-remote')) > 1 and ' ' or ''
  else
    return ''
  end
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local get_file_name = function()
  local fname = vim.fn.expand('%:p')
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
  FileName = {
    provider = get_file_name,
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}
gls.left[5] = {
  BlankSpace = {
    provider = function() return ' ' end,
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}


gls.left[6] = {
  GitIcon = {
    provider = function() return '   ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[7] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.fg,colors.line_bg,'bold'},
  }
}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left[8] = {
  BlankSpace = {
    provider = function() return ' ' end,
    condition = checkwidth,
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg}
  }
}
gls.left[9] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.green,colors.line_bg},
  }
}
gls.left[10] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[11] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.red,colors.line_bg},
  }
}
gls.left[12] = {
  LeftEnd = {
    provider = function() return '' end,
    separator = '',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.line_bg,colors.line_bg}
  }
}

gls.left[13] = {
    TrailingWhiteSpace = {
     provider = TrailingWhiteSpace,
     icon = '  ',
     highlight = {colors.yellow,colors.bg},
    }
}

gls.left[14] = {
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
