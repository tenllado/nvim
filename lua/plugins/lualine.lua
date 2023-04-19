local M = {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = { left = '', right = '' },
				-- component_separators = { left = '', right = '' },
				-- component_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				disabled_filetypes = { "dashboard", "NvimTree", "Outline", "netrw" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = {
					{
						"branch",
						icons_enabled = true,
						icon = "",
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " " },
						colored = false,
						update_in_insert = false,
						always_visible = true,
					},
				},
				lualine_b = {
					{
						"mode",
						fmt = function(str)
							return "-- " .. str .. " --"
						end,
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 1, -- 1: Relative path
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},
				lualine_x = {
					{
						"diff",
						colored = false,
						symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
						cond = function()
							return vim.fn.winwidth(0) > 80
						end,
					},
					function()
						return "sw: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
					end,
					"encoding",
					{
						"fileformat",
						symbols = {
							unix = "", -- e712
							dos = "", -- e70f
							mac = "", -- e711
						},
					},
					{
						"filetype",
						icons_enabled = false,
						icon = nil,
					},
				},
				lualine_y = {
					{
						"location",
						padding = 0,
					},
				},
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			-- winbar = {},
			-- inactive_winbar = {},
			extensions = {},
		},
	},
}

return M
