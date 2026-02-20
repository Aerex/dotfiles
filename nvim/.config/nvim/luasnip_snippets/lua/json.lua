local ls = require('luasnip')
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
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key
local paste_text = require('utils').paste_text

local function is_locale_file()
	local fn = vim.fn.expand('%:p')
	return fn:match("all.(.*).json")
end

return {
	s({ trig = 'vsnip', desc = 'Add vscode style snippet' }, fmta([[
{
  "<name>": {
    "prefix": "<prefix>",
    "description": "<desc>",
    "body": [
      "<body>"
    ]
}]], { name = i(1), prefix = i(2), desc = i(3), body = i(4) }, { indent_string = " " })),

	s({ trig = 'btr', desc = 'Add i18n json translation', condition = is_locale_file }, fmta([[
  ,
  {
    "id": "<id>",
    "translation": "<tran>"
  }
  ]], { id = f(paste_text), tran = f(paste_text) }, { indent_string = " " }))
}
