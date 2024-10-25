local fn = vim.fn

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
  spec = {
    {
      import = 'plugins'
    }
  },
  checker = {
    enabled = true
  },
  change_detection = {
    enabled = true,
    notify = true
  },
  diff = {
    cmd = 'diffview.nvim'
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tutor',
        'zipPlugin',
        'logiPat',
        'zip',
      },
    }
  }
})
