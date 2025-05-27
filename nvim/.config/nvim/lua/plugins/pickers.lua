return {
  {
    {
      'ibhagwan/fzf-lua', config = function()
        require 'fzf-lua'.setup({
          'telescope',
          actions = {
            files = {
              ["ctrl-s"]  = require 'fzf-lua.actions'.file_split,
              ["ctrl-x"]  = require 'fzf-lua.actions'.file_split,
              ["ctrl-v"]  = require 'fzf-lua.actions'.file_vsplit,
              ["default"] = require 'fzf-lua.actions'.file_edit_or_qf
            }
          }
        })
      end
    },
    { 'nvim-telescope/telescope.nvim', 
      dependencies = {  'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      config = function()
        require 'plugins.configs.pickers'.telescope.setup()
      end
    },
    {'benfowler/telescope-luasnip.nvim'},
    { 'vijaymarupudi/nvim-fzf' },
    { 'vijaymarupudi/nvim-fzf-commands' },
    { 'vifm/vifm.vim' },
  }
}
