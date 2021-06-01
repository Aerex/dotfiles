local M = {}

function noremap(normal_mappings, filetype)
	for key, value in ipairs(normal_mappings) do
		lhs = key
		rhs = '<cmd> ' .. value .. '<cr>'
		if (filetype == nil) then
			vim.api.nvim_buf_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
		else
			-- Use autocmd exec
			vim.api.nvim_exec([[
			autocmd
			]])

		end
	end
end

local MODES = { 'n', 'v', 's', 'i', 'o', 'm', 't' }

M.add = function(mappings)
	for mode, mode_mappings in pairs(mappings) do
		if MODES[mode] == nil then

	end
	if mappings['n'] then
		if mappings['n']['all'] ~= nil then
			noremap(mappings['n']['all'])
		else
			for file_type, n_value in pairs(mappings['n']) do
				for
				vim.api.nvim_exec('autocmd FileType ' file_type .. map_types_aliases[key] .. ' <silent>'
			end
		end
		vim.api.nvim_buf_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end
