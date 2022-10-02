--  check the functions from primeagen
--  https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/lua/theprimeagen/telescope.lua

local Remap = require("keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope")

nnoremap("<leader>ps", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
end)
nnoremap("<leader>pg", function()
    require('telescope.builtin').git_files()
end)
nnoremap("<Leader>pf", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end)
nnoremap("<leader>pb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<leader>vh", function()
    require('telescope.builtin').help_tags()
end)

-- TODO: Fix this immediately
nnoremap("<leader>vwh", function()
    require('telescope.builtin').help_tags()
end)

