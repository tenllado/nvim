local bl_opts = {
	-- Doc in h: bufferline-configuration
	options = {
		mode = "buffers",
		numbers = "ordinal",
		close_command = "Bdelete! %d",
		right_mouse_command = "Bdelete! %d",
		left_mouse_command = "buffer %d",
		middle_mouse_command = nil,
		indicator = {
			style = "icon",
		},
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		name_formatter = function(buf)
			local rpath = vim.call("fnamemodify", buf.path, ":~:.")
			local srpath = vim.call("pathshorten", rpath)
			return srpath
			-- local path = {}
			-- for f in string.gmatch(srpath, '[^/]+') do
			-- 	table.insert(path, f)
			-- end
			-- local name = buf.name
			-- if #path > 2 then
			-- 	name = string.format('..%s/%s', path [#path - 1], path[#path])
			-- elseif #path > 1 then
			-- 	name = string.format('%s/%s', path [#path - 1], path[#path])
			-- end
			--
			-- return name
		end,
		max_name_length = 30,
		max_prefix_length = 19, -- prefix used when a buffer is de-duplicated
		truncate_names = true,
		tab_size = 22,
		enforce_regular_tabs = false,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		-- diagnostics_indicator = function(count, level)
		-- 	local icon = level:match("error") and " " or ""
		-- 	return " " .. icon .. count
		-- end,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		custom_filter = function(buf_number)
			if vim.bo[buf_number].filetype ~= "qf" then
				return true
			end
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "",
				-- text = function()
				-- 	return vim.fn.getcwd()
				-- end,
				-- text_align = "left",
				padding = 1,
			},
			{
				filetype = "netrw",
				text = "",
				padding = 1,
			},
		},
		-- color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
		always_show_bufferline = true,
		-- hover = {
		--     enabled = true,
		--     delay = 200,
		--     reveal = {'close'}
		-- },
		-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
		--   -- add custom logic
		--   return buffer_a.modified > buffer_b.modified
		-- end
	},
}

local M = {
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local opts = { noremap = true, silent = true }
			local keymap = vim.api.nvim_set_keymap

			keymap("n", "gb", "<cmd>BufferLinePick<cr>", opts)
			keymap("n", "gB", "<cmd>BufferLinePickClose<cr>", opts)
			keymap("n", "<leader>1", "<Cmd>lua require('bufferline').go_to_buffer(1, true)<CR>", opts)
			keymap("n", "<leader>2", "<Cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", opts)
			keymap("n", "<leader>3", "<Cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", opts)
			keymap("n", "<leader>4", "<Cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", opts)
			keymap("n", "<leader>5", "<Cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", opts)
			keymap("n", "<leader>6", "<Cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", opts)
			keymap("n", "<leader>7", "<Cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", opts)
			keymap("n", "<leader>8", "<Cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", opts)
			keymap("n", "<leader>9", "<Cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", opts)
			keymap("n", "<leader>$", "<Cmd>lua require('bufferline').go_to_buffer(-1, true)<CR>", opts)
			keymap("n", "L", ":BufferLineCycleNext<CR>", opts)
			keymap("n", "H", ":BufferLineCyclePrev<CR>", opts)
			keymap("n", "<A-L>", ":BufferLineMoveNext<CR>", opts)
			keymap("n", "<A-H>", ":BufferLineMovePrev<CR>", opts)
			keymap("n", "<A-1>", ":lua require('bufferline').move_to(1)<CR>", opts)
			keymap("n", "<A-$>", ":lua require('bufferline').move_to(1)<CR>", opts)

			vim.opt.termguicolors = true

			require("bufferline").setup(bl_opts)
		end,
		lazy = true,
	},
}

return M
