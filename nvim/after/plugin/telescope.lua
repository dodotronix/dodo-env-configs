--  check the functions from primeagen
--  https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/lua/theprimeagen/telescope.lua

local telescope = require('telescope')
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>ft', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope LSP diagnostics' })

local ext = require("telescope").extensions.orgmode
vim.keymap.set("n", "<leader>fh", ext.search_headings, { desc = "Org headlines" })
vim.keymap.set("n", "<leader>ft", ext.search_tags,     { desc = "Org tags" })
vim.keymap.set("n", "<leader>r",  ext.refile_heading,  { desc = "Org refile" })
vim.keymap.set("n", "<leader>li", ext.insert_link,     { desc = "Org insert link" })
