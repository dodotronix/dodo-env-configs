local nnoremap = require('keymap').nnoremap

vim.g.lazygit_floating_window_winblend = 20
vim.g.lazygit_floating_window_scaling_factor = 1
-- vim.g.lazygit_floating_window_use_plenary = 0
-- vim.g.lazygit_use_neovim_remote = 1

nnoremap("<leader>gs", ":LazyGit\n");
nnoremap("<leader>ga", "<cmd>!git fetch --all<CR>");
