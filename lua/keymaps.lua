-- Applies defualt options that you usually want, if not present in the opts
-- argument
-- See:
-- :h nvim_set_keymap
-- :h vim.keymap.set()
local map = function(mode, lhs, rhs, opts)
	local defaults = { silent = true }
	for k, v in pairs(defaults) do
		opts[k] = v and opts[k] == nil or opts[k]
	end
	--vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
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
map("", "<Space>", "<Nop>", { desc = "ignore space" })

-- Insert Mode --
map("i", "jk", "<ESC>", { desc = "Go back to normal mode (Esc)" })

-- Normal Mode --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Focus window on the left" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus window on the right" })

-- remove search highlight
-- keymap("n", "<leader>h", ":nohlsearch", {desc = ""})

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height " })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

map("n", "K", ':<C-U>exe "Man" v:count "<C-R><C-W>"<CR>', { desc = "Open man page of word under cursor in split" })

-- Open file explorer
-- netrw
--keymap("n", "<leader>e", Ex, {desc = "Open netrw file explorer"})

-- Neotree
map("n", "<leader>ec", ":Neotree focus current<cr>", { desc = "Open file explorer in current buffer" })
map("n", "<leader>el", ":Neotree focus left<cr>", { desc = "Open and focus file explorer in left pannel" })
map("n", "<leader>ef", ":Neotree focus float<cr>", { desc = "Open and focus file explorer in float window" })
map(
	"n",
	"<leader>es",
	":Neotree focus float document_symbols<cr>",
	{ desc = "Open and focus symbol explorer in float window" }
)
map(
	"n",
	"<leader>er",
	":Neotree focus right document_symbols<cr>",
	{ desc = "Open and focus symbol explorer in right pannel" }
)

-- for Telescope
--keymap("n", "<Leader>b", ":ls<Cr>:b<Space>", {noremap = true, desc = "list buffers"})
map("n", "<Leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Telescope Select Buffer" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Select File" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope Grep Search" })
map("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Telescope Search Man Pages" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope Search Tags" })
map(
	"n",
	"<leader>fq",
	"<cmd>lua require'telescope.builtin'.quickfix{}<cr>",
	{ desc = "Telescope Search in quickfix list" }
)
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Search Diagnostics" })
map("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "Telescope Search Jumplist" })
map("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Telescope Search in NVim Registers" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Telescope Search keymaps" })
map(
	"n",
	"<leader>/",
	"<cmd>Telescope current_buffer_fuzzy_find<cr>",
	{ desc = "Telescope Search in current buffer" }
)

-- simple buffer movement
map("n", "L", ":bnext<CR>", { desc = "Go to next buffer in the buffer list" })
map("n", "H", ":bprev<CR>", { desc = "Go to previous buffer the buffer list" })
map("n", "#", ":b#<CR>", { desc = "Go to alternate buffer" })
map("n", "<leader>q", "<cmd>Bdelete<cr>", { desc = "Delete/Close buffer" })

map("n", "<c-u>", "<c-u>zz", { desc = "Scroll up in the buffer and center the cursor" })
map("n", "<c-d>", "<c-d>zz", { desc = "Scroll down in the buffer and center the cursor" })
map("n", "n", "nzzzv", { desc = "Go to next search and center the cursor" })
map("n", "N", "Nzzzv", { desc = "Go to previous search and center the cursor" })

-- Visual and Select mode --
map("v", "<", "<gv", { desc = "Reduce indent and stay in visual mode" })
map("v", ">", ">gv", { desc = "Increase indent and stay in visual mode" })
map(
	"v",
	"p",
	'"_dP',
	{ desc = 'Paste and preserve yanked text in the unnamed register " (throwing away the selected text)' }
)

-- Only visual mode --
map("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move selected text down" })
map("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move selected text up" })

-- Terminal --
map("t", "<C-h>", "<C-\\><C-N><C-w>h", {desc = "Focus window on the left"})
map("t", "<C-j>", "<C-\\><C-N><C-w>j", {desc = "Focus window below"})
map("t", "<C-k>", "<C-\\><C-N><C-w>k", {desc = "Focus window above"})
map("t", "<C-l>", "<C-\\><C-N><C-w>l", {desc = "Focus window on the right"})
