-- Applies defualt options that you usually want, if not present in the opts
-- argument
-- See:
-- :h nvim_set_keymap
local keymap = function(mode, lhs, rhs, opts)
	local defaults = { noremap = true, silent = true }
	for k, v in pairs(defaults) do
		opts[k] = v and opts[k] == nil or opts[k]
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- :h map-modes
--
-- Modes
--   normal                 "n"
--   insert                 "i"
--   visual                 "x"
--   select                 "x"
--   operator-pending       "o"
--   terminal		        "t"
--   command		        "c"
--   lang-arg
--
-- combinations:
--   visual + select        "v"
--   insert + Cmd + Lang    "l"
--
-- map!                     "!"
-- map                      ""
--   norm + vis + sel + opr
--
-- options: defualt false
--    nowait, silent, script, expr, unique
--    noremap, desc, callback, replace_keycodes

-- Ignore <Space> in normal, visual, sel and opr modes, it is the leader key
keymap("", "<Space>", "<Nop>", { desc = "ignore space" })

-- Insert Mode --
keymap("i", "jk", "<ESC>", { desc = "Go back to normal mode (Esc)" })

-- Normal Mode --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Focus window on the left" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Focus window below" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Focus window above" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Focus window on the right" })

-- remove search highlight
-- keymap("n", "<leader>h", ":nohlsearch", {desc = ""})

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height " })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

keymap("n", "K", ':<C-U>exe "Man" v:count "<C-R><C-W>"<CR>', { desc = "Open man page of word under cursor in split" })

-- Open file explorer
-- netrw
--keymap("n", "<leader>e", Ex, {desc = "Open netrw file explorer"})

-- Neotree
keymap("n", "<leader>ec", ":Neotree focus current<cr>", { desc = "Open file explorer in current buffer" })
keymap("n", "<leader>el", ":Neotree focus left<cr>", { desc = "Open and focus file explorer in left pannel" })
keymap("n", "<leader>ef", ":Neotree focus float<cr>", { desc = "Open and focus file explorer in float window" })
keymap(
	"n",
	"<leader>es",
	":Neotree focus float document_symbols<cr>",
	{ desc = "Open and focus symbol explorer in float window" }
)
keymap(
	"n",
	"<leader>er",
	":Neotree focus right document_symbols<cr>",
	{ desc = "Open and focus symbol explorer in right pannel" }
)

-- for Telescope
--keymap("n", "<Leader>b", ":ls<Cr>:b<Space>", {noremap = true, desc = "list buffers"})
keymap("n", "<Leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Telescope Select Buffer" })
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Select File" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope Grep Search" })
keymap("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Telescope Search Man Pages" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope Search Tags" })
keymap(
	"n",
	"<leader>fq",
	"<cmd>lua require'telescope.builtin'.quickfix{}<cr>",
	{ desc = "Telescope Search in quickfix list" }
)
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Search Diagnostics" })
keymap("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "Telescope Search Jumplist" })
keymap("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Telescope Search in NVim Registers" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Telescope Search keymaps" })
keymap(
	"n",
	"<leader>/",
	"<cmd>Telescope current_buffer_fuzzy_find<cr>",
	{ desc = "Telescope Search in current buffer" }
)

-- simple buffer movement
keymap("n", "L", ":bnext<CR>", { desc = "Go to next buffer in the buffer list" })
keymap("n", "H", ":bprev<CR>", { desc = "Go to previous buffer the buffer list" })
keymap("n", "#", ":b#<CR>", { desc = "Go to alternate buffer" })
keymap("n", "<leader>q", "<cmd>Bdelete<cr>", { desc = "Delete/Close buffer" })

keymap("n", "<c-u>", "<c-u>zz", { desc = "Scroll up in the buffer and center the cursor" })
keymap("n", "<c-d>", "<c-d>zz", { desc = "Scroll down in the buffer and center the cursor" })
keymap("n", "n", "nzzzv", { desc = "Go to next search and center the cursor" })
keymap("n", "N", "Nzzzv", { desc = "Go to previous search and center the cursor" })

-- Visual and Select mode --
keymap("v", "<", "<gv", { desc = "Reduce indent and stay in visual mode" })
keymap("v", ">", ">gv", { desc = "Increase indent and stay in visual mode" })
keymap(
	"v",
	"p",
	'"_dP',
	{ desc = 'Paste and preserve yanked text in the unnamed register " (throwing away the selected text)' }
)

-- Only visual mode --
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move selected text down" })
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move selected text up" })

-- Terminal --
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", {desc = "Focus window on the left"})
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", {desc = "Focus window below"})
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", {desc = "Focus window above"})
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", {desc = "Focus window on the right"})
