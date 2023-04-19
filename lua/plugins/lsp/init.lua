local function mason_setup()
	local settings = {
		ui = {
			border = "none",
			icons = {
				package_installed = "◍",
				package_pending = "◍",
				package_uninstalled = "◍",
			},
		},
		log_level = vim.log.levels.INFO,
		max_concurrent_installers = 4,
	}

	require("mason").setup(settings)
end

local servers = {
	"cmake", -- or neocmake?
	"bashls",
	"clangd",
	"pyright",
	"jsonls",
	"texlab",
	"lua_ls", -- TODO: have a look to luau_lsp
	"vimls",
	"ltex", -- TODO: compare ltex and texlab
}

local function mason_lspconfig_setup()
	-- mason_lspconfig loads/requires all the servers in ensure_installed
	require("mason-lspconfig").setup({
		ensure_installed = servers,
		automatic_installation = true,
	})
end

local function lsp_ui_setup()
	-- see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		-- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- see :h  vim.diagnostic.config
	local config = {
		-- disable virtual text
		virtual_text = false,
		signs = true,
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
			--			max_width = 80,
		},
	}
	vim.diagnostic.config(config)

	-- Alternative: replace the open_floating_preview as in
	-- https://neovim.discourse.group/t/lsp-hover-float-window-too-wide/3276/2
	local lsp_float_opts = { border = "rounded", max_width = 80 }
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp_float_opts)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp_float_opts)
end

local function null_ls_setup()
	local null_ls_status_ok, null_ls = pcall(require, "null-ls")
	if not null_ls_status_ok then
		return
	end

	-- Supported tools, look in: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	-- local code_actions = null_ls.builtins.code_actions

	local sources = {
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.black.with({ extra_args = { "--fast" } }), -- for python files
		formatting.stylua, -- for lua files
		diagnostics.flake8, -- for python files
--		null_ls.builtins.code_actions.gitsigns, -- gives warning: multiple dfferent client offset_encodings detected for buffer, this is not supported yet
	}

	null_ls.setup({ debug = false, sources = sources })
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		vim.cmd([[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]])
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<A-k>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<A-j>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>l", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]]) -- TODO: find a good keymap
end

local function on_attach(client, bufnr)
	-- We can disable some capabilities for each server (here called client)
	-- if client.name == "tsserver" then
	--   client.server_capabilities.documentFormattingProvider = false
	-- end
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local function lsp_servers_setup(lspconfig)
	-- We add a capabilities field to the options table of each server with all
	-- the available capabilities by default. The on_attach callback can be used
	-- to disable some based on server name
	local capabilities = nil
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.default_capabilities()
	end

	for _, server in pairs(servers) do
		local opts = { on_attach = on_attach, capabilities = capabilities }
		local opts_file = "plugins.lsp.options." .. vim.split(server, "@")[1]
		local require_ok, server_opts = pcall(require, opts_file)
		if require_ok then
			opts = vim.tbl_deep_extend("force", server_opts, opts)
		end
		lspconfig[server].setup(opts)
	end
end

local M = {
	{
		"williamboman/mason.nvim", -- Easy installation of Language Servers
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim", -- Binding between lspconfig and mason LS
	},
	{
		"jose-elias-alvarez/null-ls.nvim", -- Allows the use of non-LSP aware tools with neovim's LSP
		dependencies = {"nvim-lua/plenary.nvim"},
	},
	{
		"neovim/nvim-lspconfig", -- configure the LSP
		config = function()
			-- documentation of mason-lspconfig indicates that the plugins must be setup
			-- in order: mason, mason-lspconfig, lspconfig
			mason_setup()
			mason_lspconfig_setup()
			lsp_ui_setup()
			lsp_servers_setup(require("lspconfig"))
			null_ls_setup()
		end,
	},
}

return M
