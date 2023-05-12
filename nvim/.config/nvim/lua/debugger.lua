local M = {}
local utils = require('utils')
local autocmd = utils.autocmd
local default_key_maps = {}
local api = vim.api
local dap = require('dap')
local dapui = require('dapui')

M.hover_var = function()
  local status = dap.status()
  if status then
    local w = require'dap.ui.widgets'
    w.hover()
  end
end

M.toggle_breakpoints_qf = function()
  -- Add breakpoints to quickfix window
  require 'dap'.list_breakpoints()
  -- Load trouble
  require 'packer'.loader('trouble.nvim')
  -- open trouble quickfix
  require 'trouble'.open({ provider = 'qf' })
end

M.restore_keymaps = function()
  for _, keymap in pairs(default_key_maps) do
    local rhs = keymap.rhs or keymap.callback
    vim.keymap.set(keymap.mode, keymap.lhs, rhs, { buffer = keymap.buffer, silent = true })
  end
  default_key_maps = {}
end

M.debugger_keymaps = function()
  local ref_map = { 'K', '<A-j>','<A-k>', '<A-l>', '<A-h>', '<leader>dr', '<leader>dR', '<leader>dl', 'qq' }
  local api = vim.api
  for _, buf in pairs(api.nvim_list_bufs()) do
      local keymaps = api.nvim_buf_get_keymap(buf, 'n')
      for _, keymap in pairs(keymaps) do
        -- save default keymap to restore after session is over
        if utils.list_contains(ref_map, keymap.lhs) then
          table.insert(default_key_maps, keymap)
          api.nvim_buf_del_keymap(buf, 'n', keymap.lhs)
        end
      end
      local ok, wk = pcall(require, 'which-key')
      if ok then
        local options = { silent = true, buffer = buf }
        wk.register({
          K = {function() require('dap.ui.widgets').hover() end, 'Hover'},
          ['<A-j>'] = { function() require('dap').step_over() end, 'Step Over'},
          ['<A-k>'] = { function() require('dap').step_into() end, 'Step Into'},
          ['<A-l>'] = { function() require('dap').step_out() end, 'Step Out'},
          ['<A-h>'] = { function() require('dap').continue() end, 'Continue'},
          ['<leader>dr'] = {function() require'dap'.float_element('repl', { enter = true }) end, 'REPL'},
          ['<leader>dR'] = {function() require'dap'.repl.toggle({height = 7}); utils.send_keys('<C-w>b', 'n') end, 'REPL'},
          ['<leader>dl'] = {function() M.toggle_breakpoints_qf() end, 'Show breakpoint list'},
        }, options)
      end
    end
end

dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = {nil, stdout},
    args = {"dap", "-l", "127.0.0.1:" .. port},
    detached = true
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print('dlv exited with code', code)
    end
  end)
  assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require('dap.repl').append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(
    function()
      callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "./${relativeFileDirname}",
    args= { "card", "list", "-q", "deck:Vocabulary vaci" },
    mode = "debug"
  },
  {
    type = "go",
    name = "Debug with args",
    request = "launch",
    program = "${file}",
    mode = "debug",
    args = function()
      resp = vim.fn.input("Enter args separated by space: ")
      args = vim.fn.split(resp, " ")
      print(vim.inspect(args))
      return args
    end
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }, {
      type= "go",
      name= "anki-cli card list",
      request= "launch",
      program = function()
        local w = vim.lsp.buf.list_workspace_folders()[1]
        return w .. "/cmd/anki/main.go"
      end,
      args= { "card", "list", "-q", "too already" },
      mode= "debug"
  }
}
dap.repl.commands =
  vim.tbl_extend(
    "force",
    dap.repl.commands,
    {
      continue = {".continue", "c"},
      next_ = {".next", ".n"},
      into = {".into", "s"},
      out = {".out", "r"},
      scopes = {".scopes", "a"},
      threads = {".threads", "t"},
      frames = {".frames", "f"},
      exit = {"exit", ".exit"},
      up = {".up", "j"},
      down = {".down", "k"},
      goto_ = {".goto", "g"},
      into_targets = {".into_targets", "t"},
      capabilities = {".capabilities", ".ca"},
      custom_commands = {
        [".echo"] = function(text)
          dap.repl.append(text)
        end
      }
    }
  )
vim.g.dap_virtual_text = true -- 'all frames'
vim.fn.sign_define("DapBreakpoint", {text = "●", texthl = "", linehl = "", numhl = ""})
vim.fn.sign_define('DapStopped', {text='▶', texthl='', linehl='NvimDapStopped', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='ErrorMsg', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected',  {text='', texthl='WarningMsg', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint',            {text='', texthl='ErrorMsg', linehl='', numhl=''})
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
  },
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 55,
      position = 'left',
    },
    {
      elements = {
        'repl'
      },
      size = 10,
      position = 'bottom',
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
  },
  windows = { indent = 1 },
})

-- Toggle dap ui when debugger starts and exits
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function()  dapui.close()end

dap.listeners.after.event_terminated['me'] = M.restore_keymaps
dap.listeners.after.event_initialized['me'] = M.debugger_keymaps

--dap.set_log_level('TRACE')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  callback = function()
    require('dap.ext.autocompl').attach()
  end
})


M.toggle_dap_ele = function(ele, type)
  local widgets = require('dap.ui.widgets')
  local eles = {
    frames =  widgets.frames,
    scopes = widgets.scopes
  }
  if ele then
    if type == "float" then
      local wind = widgets.centered_float(eles[ele])
    end
  end
end

M.start_or_continue  = function()
  if not vim.g.loaded_vscode_dap then
    vim.g.loaded_vscode_dap = 1
    local workspace = nil
    if #vim.lsp.buf.list_workspace_folders() > 0 then
      workspace = vim.lsp.buf.list_workspace_folders()[1] .. '/.vscode/launch.json'
    end
    require('dap.ext.vscode').load_launchjs(workspace)
  end

  dap.continue()
end

return M
