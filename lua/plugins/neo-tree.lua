local M = {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				"s1n7ax/nvim-window-picker",
				--tag = "v1.*",
				config = function()
					require("window-picker").setup({
						autoselect_one = true,
						include_current = false,
						filter_rules = {
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
						other_win_hl_color = "#e35e4f",
					})
				end,
			},
		},
		config = function()
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

			require("neo-tree").setup({
				close_if_last_window = false,
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
				sort_case_insensitive = false,
				sort_function = nil, -- use builtin
				sources = {
					"filesystem",
					"buffers",
					"git_status",
					"document_symbols",
				},
				default_component_configs = {
					container = {
						enable_character_fade = true,
					},
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = true,
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "ﰊ",
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = "[+]",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = true,
						use_git_status_colors = false,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							added = "✚",
							modified = "",
							deleted = "✖",
							renamed = "",
							-- Status type
							untracked = "",
							ignored = "",
							unstaged = "",
							staged = "",
							conflict = "",
						},
					},
				},
				commands = {},
				window = {
					position = "left", -- having problems setting current as default
					-- related github issue: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/845
					-- should be fixed soon
					width = 30, -- for left/right trees
					same_level = false,
					insert_as = "child",
					mappings = {
						["<space>"] = {
							"toggle_node",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "revert_preview",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["s"] = "open_split",
						["v"] = "open_vsplit",
						["S"] = "split_with_window_picker",
						["V"] = "vsplit_with_window_picker",
						["t"] = "open_tabnew",
						-- ["<cr>"] = "open_drop",
						-- ["t"] = "open_tab_drop",
						["w"] = "open_with_window_picker",
						--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
						["C"] = "close_node",
						-- ['C'] = 'close_all_subnodes',
						["z"] = "close_all_nodes",
						--["Z"] = "expand_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						-- ["c"] = {
						--  "copy",
						--  config = {
						--    show_path = "none" -- "none", "relative", "absolute"
						--  }
						--}
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "none", -- "prev_source",
						[">"] = "none", -- "next_source",
					},
					mapping_options = {
						noremap = true,
						nowait = true,
					},
				},
				event_handlers = {
					{
						event = "file_opened",
						handler = function(file_path)
							--auto close
							require("neo-tree").close_all()
						end,
					},
				},
				nesting_rules = {},
				filesystem = {
					hijack_netrw_behavior = "open_current", -- "open_default", "open_current", "disabled",
					follow_current_file = false,
					group_empty_dirs = false,
					use_libuv_file_watcher = false,
					find_by_full_path_words = false,
					-- bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
					-- cwd_target = {
					-- 	sidebar = "tab", -- sidebar is when position = left or right
					-- 	current = "window", -- current is when position = current
					-- },
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = true,
						hide_gitignored = true,
						hide_hidden = true, -- only works on Windows for hidden files/directories
						hide_by_name = {
							".DS_Store",
							--"node_modules"
						},
						hide_by_pattern = { -- uses glob style patterns
							--"*.meta",
							--"*/src/*/tsconfig.json",
						},
						always_show = { -- remains visible even if other settings would normally hide it
							".gitignored",
						},
						never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
							--".DS_Store",
							--"thumbs.db"
						},
						never_show_by_pattern = { -- uses glob style patterns
							--".null-ls_*",
						},
					},
					-- instead of relying on nvim autocmd events.
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["-"] = "navigate_up", -- netrw
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							-- ["D"] = "fuzzy_sorter_directory",
							["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
						},
						fuzzy_finder_mappings = {
							-- define keymaps for filter popup window in fuzzy_finder_mode
							["<down>"] = "move_cursor_down",
							["<C-n>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<C-p>"] = "move_cursor_up",
						},
					},
					commands = {}, -- Add a custom command or override a global one using the same function name
				},
				buffers = {
					follow_current_file = true, -- This will find and focus the file in the active buffer every
					-- time the current file is changed while the tree is open.
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						mappings = {
							["/"] = "fuzzy_finder",
							["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
				document_symbols = {
					client_filters = "first",
					renderers = {
						root = {
							{ "indent" },
							{ "icon", default = "C" },
							{ "name", zindex = 10 },
						},
						symbol = {
							{ "indent", with_expanders = true },
							{ "kind_icon", default = "?" },
							{
								"container",
								content = {
									{ "name", zindex = 10 },
									{ "kind_name", zindex = 20, align = "right" },
								},
							},
						},
					},
					window = {
						mappings = {
							["<cr>"] = "jump_to_symbol",
							["o"] = "jump_to_symbol",
							["A"] = "noop", -- also accepts the config.show_path and config.insert_as options.
							["d"] = "noop",
							["y"] = "noop",
							["x"] = "noop",
							["p"] = "noop",
							["c"] = "noop",
							["m"] = "noop",
							["a"] = "noop",
						},
					},
					custom_kinds = {
						-- define custom kinds here (also remember to add icon and hl group to kinds)
						-- ccls
						-- [252] = 'TypeAlias',
						-- [253] = 'Parameter',
						-- [254] = 'StaticMethod',
						-- [255] = 'Macro',
					},
					kinds = {
						Unknown = { icon = "?", hl = "" },
						Root = { icon = "", hl = "NeoTreeRootName" },
						File = { icon = "", hl = "Tag" },
						Module = { icon = "", hl = "Exception" },
						Namespace = { icon = "", hl = "Include" },
						Package = { icon = "", hl = "Label" },
						Class = { icon = "", hl = "Include" },
						Method = { icon = "", hl = "Function" },
						Property = { icon = "", hl = "@property" },
						Field = { icon = "", hl = "@field" },
						Constructor = { icon = "", hl = "@constructor" },
						Enum = { icon = "了", hl = "@number" },
						Interface = { icon = "", hl = "Type" },
						Function = { icon = "", hl = "Function" },
						Variable = { icon = "", hl = "@variable" },
						Constant = { icon = "", hl = "Constant" },
						String = { icon = "", hl = "String" },
						Number = { icon = "", hl = "Number" },
						Boolean = { icon = "", hl = "Boolean" },
						Array = { icon = "", hl = "Type" },
						Object = { icon = "", hl = "Type" },
						Key = { icon = "", hl = "" },
						Null = { icon = "", hl = "Constant" },
						EnumMember = { icon = "", hl = "Number" },
						Struct = { icon = "", hl = "Type" },
						Event = { icon = "", hl = "Constant" },
						Operator = { icon = "", hl = "Operator" },
						TypeParameter = { icon = "", hl = "Type" },
						-- ccls
						-- TypeAlias = { icon = ' ', hl = 'Type' },
						-- Parameter = { icon = ' ', hl = '@parameter' },
						-- StaticMethod = { icon = 'ﴂ ', hl = 'Function' },
						-- Macro = { icon = ' ', hl = 'Macro' },
					},
				},
			})

			vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
		end,
	},
}

return M
