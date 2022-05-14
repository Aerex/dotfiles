local M = {}
local utils = require('utils')
local default_key_maps = {}

M.restore_keymaps = function()
  local api = vim.api
  for _, keymap in pairs(default_key_maps) do
    api.nvim_buf_set_keymap(
      keymap.buffer,
      keymap.mode,
      keymap.lhs,
      keymap.rhs,
      { silent = keymap.silent == 1 }
    )
  end
  default_key_maps = {}
end

M.debugger_keymaps = function()
  local ref_map = { 'K', '<A-j>','<A-k>', '<A-l>' }
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
        options = { silent = true, buffer = buf }
        wk.register({
          K = {'<cmd>lua require("dap.ui.widgets").hover()<cr>', 'Hover', options },
          ['<A-j>'] = { '<cmd>lua require("dap").step_over()<cr>', 'Step Over', options },
          ['<A-k>'] = { '<cmd>lua require("dap").step_into()<cr>', 'Step Into', options },
          ['<A-l>'] = { '<cmd>lua require("dap").step_out()<cr>', 'Step Out', options },
          ['<leader>dr'] = {'<cmd>lua require"dap".repl.toggle({height = 7})<CR><C-w>l', 'REPL', options },
          ['<A-h>'] = { '<cmd>lua require("dap").continue()<cr>', 'Continue', options },
        })
      end
    end
end

local dap = require('dap')
local dapui = require('dapui')
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
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with 'id' and 'size' keys
      {
        id = 'scopes',
        size = 25, -- Can be float or integer > 1
      },
      { id = 'breakpoints', size = 0.25 },
      { id = 'stacks', size = 0.25 },
      { id = 'watches', size = 0.25 },
    },
    size = 55,
    position = 'left', -- Can be 'left' or 'right'
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

dap.set_log_level('TRACE')

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
  local dap = require'dap'
  if not vim.g.loaded_vscode_dap then
    vim.g.loaded_vscode_dap = 1
    local workspace = None
    if #vim.lsp.buf.list_workspace_folders() > 0 then
      workspace = vim.lsp.buf.list_workspace_folders()[1] .. '/.vscode/launch.json'
    end
    require('dap.ext.vscode').load_launchjs(workspace)
  end

  dap.continue()
end

M.hover_var = function()
  local dap = require'dap'
  local status = dap.status()
  if status then
    local w = require'dap.ui.widgets'
    w.hover()
  end
end

M.toggle_breakpoints_qf = function()
  -- Add breakpoints to quickfix window
  require'dap'.list_breakpoints()
  -- Load trouble
  require'packer'.loader('trouble.nvim')
  -- open trouble quickfix
  require'trouble'.open({ provider = 'quickfix'})
end

return M
