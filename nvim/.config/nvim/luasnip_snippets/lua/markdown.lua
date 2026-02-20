local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmta = require('luasnip.extras.fmt').fmta
local paste_text = require('utils').paste_text

local function is_tmp_md()
  local fn = vim.fn.expand('%:p')
  return fn:match("/tmp/\\d+.md")
end

return {
  s({ trig = '@chris', desc = 'Print GH @chrism1 handler', condition = is_tmp_md },
    {
      t({ '@chrism1 ' })
    }
  ),
  s({ trig = '@rs', desc = 'Print GH @rsteph handler', condition = is_tmp_md },
    {
      t({ '@rsteph' })
    }
  ),
  s({ trig = '@cl', desc = 'Print GH @clays handler', condition = is_tmp_md },
    {
      t({ '@clays ' })
    }
  ),

  s('ctx', c(1, {
    t({ '# Context', ' ', 'The purpose of this PR' }),
    t('# Context')
  }
  )),

	s({ trig = 'plink', desc = 'Create link from clipboard'},
  fmta("[<text>](<url>)",
  { text = i(1), url = f(paste_text)}, { indent_string = " "}
  ))

}
