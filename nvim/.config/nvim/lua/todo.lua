local M = {}
M.setup = function()
  local cfg = {
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      REMOVEME = { icon = "", color = "warning"},
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {
        'snippets'
      }, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "LspDiagnosticsError", "ErrorMsg", "#DC2626" },
      warning = { "LspDiagnosticsWarning", "WarningMsg", "#FBBF24" },
      info = { "LspDiagnosticsInformation", "#2563EB", "#00ff00" },
      hint = { "LspDiagnosticsHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    }
  }

  if not vim.fn.executable('rg') then
    cfg.search = {
      command = "grep",
      args = {
        "--color=never",
        "--with-filename",
        "--line-number"
      }
    }
  end

  local ok, lcfg = pcall(require, 'nvim-local')
  local config
  if ok then
    config = vim.tbl_deep_extend("force", cfg, lcfg.get_todo_config())
  else
    config = cfg
  end

  local ok_, todoc = pcall(require, 'todo-comments')
  if ok_ then
    todoc.setup(config)
  end
end
return M
