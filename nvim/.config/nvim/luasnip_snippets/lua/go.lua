local ls = require('luasnip')
local t = ls.text_node
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local s = ls.snippet


return {
	s('gee', {

		t("Expect("), i(1), t(").To(HaveOccurred())")
	}),

	s('stjs', fmt([[strings.Join({array}, " ")]], 
		{ array = i(1) }, {}
	)),

  s('logn', fmt([[fmt.Println({ln})]],
    { ln = i(1) }, {}
  ))
}
