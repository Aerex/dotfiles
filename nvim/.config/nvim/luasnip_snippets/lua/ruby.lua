local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local s = ls.snippet
local extras = require("luasnip.extras")
local rep = extras.rep
local make_condition = require('luasnip.extras.conditions')


local is_cucumber_directive = function()
  local line = vim.api.nvim_get_current_line()
  local match vim.regex('Given'):match_str(line)
  if match then 
    return true 
  end
    return false 
end

		-- { t({'puts "'}), i(1), t({'-> #{'}), i(1) , t({'}"'})  })

return 
{
	s('rg', {  t("\"([^\"]*)\"") } )
}, 
{
	s({trig = 'log', desc = 'Print variable', snippetType = 'snippet'},

		{ t({'puts "\\n'}), i(1) , t({' -> '}), t({' #{'}), rep(1), t({'}"'}) })
},
{
	s('todo',
		{ t({'#TODO(me): '}), i(1) })
}
