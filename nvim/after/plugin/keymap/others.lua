
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>m', ':w<CR>:source %<CR>', opts)

-- Normal-mode commands
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('x', '<leader>p', '"_dP', opts)
