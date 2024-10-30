local M = {}
M.setup = function()
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

M.test_file = function()
  require('neotest').run.run(vim.fn.expand('%'))
end

M.test_nearest = function()
  require('neotest').run.run()
end

M.summary = function()
  require('neotest').summary.toggle()
end

M.debug_file = function()
  require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })
end

M.debug_nearest = function()
  require('neotest').run.run_last({ strategy = 'dap' })
end

M.output = function(opts)
  require('neotest').output.open(opts)
end

M.next_fail = function()
  require('neotest').jump_next({ status = 'failed' })
end

M.prev_fail = function()
  require('neotest').jump.prev({ status = 'failed' })
end

return M
