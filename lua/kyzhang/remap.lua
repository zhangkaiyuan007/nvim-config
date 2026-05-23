local which_key = require "which-key"
local builtin = require('telescope.builtin')

-- basic mappings
vim.keymap.set('i', 'jj', '<Esc>', { desc = "Exit insert mode" })
vim.keymap.set('i', 'jk', '<Esc>', { desc = "Exit insert mode" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-v>', '<C-w>v')
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = "Save file" })
vim.keymap.set('n', 'q', '<cmd>q<cr>', { desc = "Quit file" })

-- which_key
which_key.add({
  { "<leader>e",  "<cmd>NvimTreeToggle<cr>",                              desc = "File Explorer" },
  { "<leader>p",  "\"_dP",                                                desc = "Paste without overwrite",     mode = { "n", "v" } },
  { "<leader>/",  "<Plug>(comment_toggle_linewise_current)",              desc = "Comment Toggle" },
  { "<leader>s",  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Search/Replace word" },

  -- Telescope
  { "<leader>f",  group = "Find" },
  { "<leader>ff", builtin.find_files,                                     desc = "Files" },
  { "<leader>fg", builtin.git_files,                                      desc = "Git Files" },
  { "<leader>fl", builtin.live_grep,                                      desc = "Live Grep" },
  { ";",          builtin.buffers,                                        desc = "Buffers" },

  -- Terminal (ToggleTerm)
  { "<leader>t",  group = "Terminal" },
  { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",                  desc = "Float Terminal" },
  { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>",       desc = "Vertical Terminal (Right)" },
  { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>",             desc = "Horizontal Terminal (Bottom)" },
})

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }

    which_key.add({
      { "gd",         vim.lsp.buf.definition,    desc = "Go to definition", buffer = event.buf },
      { "K",          vim.lsp.buf.hover,         desc = "Hover info",       buffer = event.buf },
      { "[d",         vim.diagnostic.goto_next,  desc = "Next Diagnostic",  buffer = event.buf },
      { "]d",         vim.diagnostic.goto_prev,  desc = "Prev Diagnostic",  buffer = event.buf },
      { "<leader>l",  group = "LSP",             buffer = event.buf },
      { "<leader>lf", vim.lsp.buf.format,        desc = "Format",           buffer = event.buf },
      { "<leader>la", vim.lsp.buf.code_action,   desc = "Code action" },
      { "<leader>lr", vim.lsp.buf.references,    desc = "References" },
      { "<leader>ln", vim.lsp.buf.rename,        desc = "Rename" },
      { "<leader>ld", vim.diagnostic.open_float, desc = "Line Diagnostic" },
    })
  end,
})
