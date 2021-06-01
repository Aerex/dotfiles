require'neogit'.setup {
  disable_signs = false,
  disable_context_highlighting = false,
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      ["B"] = "BranchPopup",
      ["="] = "Toggle",
    }
  }
}

-- Goal
--require'nvim-fzf'.setup {
--  mappings = {
--    n = {
--      ["<C-p>"] = "lua require('nvim-fzf').git"
--    }
--  }
--}

--Temp
vim.api.nvim_set_keymap('n', '<Leader>p', "<cmd>lua require('nvim-fzf').pickers.git()<cr>", { noremap = true, silent = true })
