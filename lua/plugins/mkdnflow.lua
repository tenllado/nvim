local template = [[
# {{ title }}
Date: {{ date }}
Filename: {{ filename }}
]]

return {
	{
		"jakewvincent/mkdnflow.nvim",
		opts = {
			perspective = {
				priority = "current",
				fallback = "first",
				root_tell = false,
				nvim_wd_heel = false,
				update = false,
			},
			links = {
				transform_explicit = function(text)
					text = text:gsub(" ", "-")
					text = text:lower()
					local cpath = vim.fn.expand("%:p:h")
					if string.match(cpath, "vimwiki/diary") ~= nil then
						text = os.date("%Y-%m-%d_") .. text
					end
					return text
				end,
			},
			new_file_template = {
				template = template,
				placeholders = {
					before = {
						date = function()
							return os.date("%A, %B %d, %Y") -- Wednesday, March 1, 2023
						end
					},
					after = {
						filename = function()
							return vim.api.nvim_buf_get_name(0)
						end
					}
				}
			}
		},
	},
}
