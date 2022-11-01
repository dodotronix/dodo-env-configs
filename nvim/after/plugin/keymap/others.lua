
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>m', ':w<CR>:source %<CR>', opts)
