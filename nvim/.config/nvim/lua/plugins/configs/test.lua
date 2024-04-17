local ok, ultest = pcall(require, 'ultest')
local M = {}
if ok then
  vim.g["test#go#gotest#options"] = "-v --short"
  vim.g.ultest_use_pty = 1
  vim.g.ultest_output_on_run = 1
  vim.g.ultest_output_on_line = 1
  vim.g.ultest_virtual_text = 1
  vim.cmd('let test#strategy = "dispatch"')
  vim.cmd('let test#go#ginkgo#options = { \'all\': \'-noColor\', \'file\' : \'-noColor -focus\'}')
end

M.setup = function()
  local ok, ultest = pcall(require, 'ultest')
  if ok then
    vim.g.ultest_use_pty = 1
    vim.g.ultest_deprecation_notice = 0
    vim.g.ultest_output_on_run = 0
    vim.g.ultest_output_on_line = 0
    vim.g.ultest_virtual_text = 1
    vim.cmd('let test#strategy = "dispatch"')
    vim.cmd('let test#go#ginkgo#options = { \'all\': \'-noColor\', \'file\' : \'-noColor -focus\'}')

    ultest.setup({
      builders = {
        ["go#gotest"] = function(cmd)
          local args = {}
          for i = 3, #cmd - 1, 1 do
            local arg = cmd[i]
            if vim.startswith(arg, "-") then
              -- Delve requires test flags be prefix with 'test.'
              arg = "-test." .. string.sub(arg, 2)
            end
            args[#args + 1] = arg
          end
          return {
            dap = {
              type = "go",
              request = "launch",
              mode = "test",
              program = "${workspaceFolder}",
              dlvToolPath = vim.fn.exepath("dlv"),
              args = args
            },
            parse_result = function(lines)
              return lines[#lines] == "FAIL" and 1 or 0
            end
          }
        end
      }
    })
  end
  local ok_t, neotest = pcall(require, 'neotest')
  if ok_t then
    local cfg = {
      adapters = {}
    }
    local gotest, _ = pcall(require, 'neotest-go')
    if gotest then
      table.insert(cfg.adapters, require('neotest-go'))
    end
   require('neotest').setup(cfg)
  end
end

M.neotest_runtime = function(ft)
  local supported_runtimes = {"python", "go", "typescript", "ruby"}
  return vim.tbl_contains(supported_runtimes, ft)
end

M.test_file = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').run.run(vim.fn.expand('%'))
  else
    vim.cmd[[Ultest]]
  end
end

M.test_nearest = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').run.run()
  else
    vim.cmd[[UltestNearest]]
  end
end

M.summary = function()
  if M.neotest_runtime(vim.bo.filetype) or vim.bo.filetype == 'neotest-summary' then
    require('neotest').summary.toggle()
  else
    vim.cmd[[UltestSummary!]]
  end
end

M.debug_file = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})
  else
    vim.cmd[[UltestDebug]]
  end
end

M.debug_nearest = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').run.run_last({strategy = 'dap'})
  else
    vim.cmd[[UltestDebugNearest]]
  end
end

M.output = function(opts)
  opts = opts or {}
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').output.open(opts)
  elseif opts.enter then
    vim.cmd[[call ultest#output#jumpto()]]
  else
    vim.cmd[[UltestOutput]]
  end
end

M.next_fail = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').jump_next({ status = 'failed' })
  else
    vim.cmd[[<Plug>(ultest-next-fail)]]
  end
end

M.prev_fail = function()
  if M.neotest_runtime(vim.bo.filetype) then
    require('neotest').jump.prev({ status = 'failed' })
  else
    vim.cmd[[<Plug>(ultest-prev-fail)]]
  end
end

return M
