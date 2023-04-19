-- a plae for core or simple plugins that do not require additional
-- configuration
local M = {
	{"nvim-lua/popup.nvim", lazy = true},
	{
		"moll/vim-bbye",
		lazy = true,
		cmd = "Bdelete"
	},
}
return M
