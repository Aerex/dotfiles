local M = {}
local g = vim.g
--local wk = require('which-key') local dap = require('dap')
--local dapui = require('dapui')
--
--wk.register({
--  d = {
--    name = 'Debugger',
--    b =  {
--      name = 'Breakpoints',
--      p = { function() dap.toggle_breakpoint() end, 'Toggle Breakpoint' },
--    },
--    s = {
--      name = 'Step',
--      o = { function() dap.step_over() end, 'Step Over' },
--      O = { function() dap.step_out() end, 'Step Out' },
--      i = { function() dap.step_into() end, 'Step In' },
--    },
--    x = {
--      name = 'Connection',
--      r = { function() dap.disconnect({restart = true}) end, 'Restart' }
--      e = { function() dap.disconnect({terminateDebuggee = true}) end, 'Terminate and Disconnect' }
--    }
--    c = { function() dap.continue() end, 'Continue' }
--  {
--    prefix = '<Leader>'
--  }
--})
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
    args = {"account"},
    stopOnEntry = true,
    mode = "debug"
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
    toggle = 't',
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with 'id' and 'size' keys
      {
        id = 'scopes',
        size = 0.25, -- Can be float or integer > 1
      },
      { id = 'breakpoints', size = 0.25 },
      { id = 'stacks', size = 0.25 },
      { id = 'watches', size = 00.25 },
    },
    size = 40,
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
dap.listeners.before.event_terminated['dapui_config'] = function()  dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

require('dap.ext.vscode').load_launchjs()

vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")

local ok_dap_vt, nvim_dap_vt =  pcall(require, 'nvim-dap-virtual-text')
if ok_dap_vt then
  nvim_dap_vt.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    -- experimental features:
    virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!) virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
                                        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}
end

M.start_or_continue = function()
  if not g.loaded_vs_launchjson then
    g.loaded_vs_launchjson = 1
    local launchjson_path
    if #vim.lsp.buf.list_workspace_folders() > 0 then
      launchjson_path = vim.lsp.buf.list_workspace_folders()[1] .. '/.vscode/launch.json'
      require'dap.ext.vscode'.load_launchjs(launchjson_path)
    end
  end
  dap.continue()
end

M.toggle_breakpoints_qf = function()
  -- Add breakpoints to quickfix window
  require'dap'.list_breakpoints()
  -- Load trouble
  require'packer'.loader('trouble.nvim')
  -- open trouble quickfix
  require'trouble'.open({ provider = 'quickfix'})
end



function debug_cli()
  --vim.fn.input
end

return M
