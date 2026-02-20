local ls = require('luasnip')
local t = ls.text_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local c = ls.choice_node
local fmta = require('luasnip.extras.fmt').fmta
local i = ls.insert_node
local s = ls.snippet

local function is_test_file()
	local fn = vim.fn.expand('%:p')
	return fn:match(".*_test.go")
end

local function print_ln_number()
	return tostring(vim.fn.line('.'))
end

return {
	s('gee', {

		t("Expect("), i(1), t(").To(HaveOccurred())")
	}),

	s('stjs', fmt([[strings.Join({array}, " ")]],
		{ array = i(1) }, {}
	)),

	s('logn', fmt([[fmt.Println("{ln}")]],
		{ ln = f(print_ln_number) }, {}
	)),
	s('i18n', c(1,
		fmta([[i18n.T("<message>", map[string]any{
	  "<flag>": "<flag_value>",
})"]], { message = i(1), flag = i(2), flag_value = i(3) }, {}),
		fmta([[i18n.T("<message>")]], { message = i(1) }, {}), {})),

	s({ trig = 'gd', desc = 'Add gomega Describe snippet', condition = is_test_file },
		fmta([[
		var _ = Describe("<name>", func() {
			<content>
		})
	]], { name = i(1), content = i(2) }, {})
	),
	s({ trig = 'igo', desc = 'Add import gomega/ginkgo', condition = is_test_file },
		fmta([[
		import (
			. "github.com/onsi/gomega"
			. "github.com/onsi/ginkgo"
		)
	]], {}, {})
	)

}
