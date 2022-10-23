local nnoremap = require("keymap").nnoremap

local silent = { silent = true }

nnoremap("<leader>a", function() require("harpoon.mark").add_file() end, silent)
nnoremap("<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, silent)

nnoremap("<leader>h", function() require("harpoon.ui").nav_file(1) end, silent)
nnoremap("<leader>t", function() require("harpoon.ui").nav_file(2) end, silent)
nnoremap("<leader>n", function() require("harpoon.ui").nav_file(3) end, silent)
nnoremap("<leader>s", function() require("harpoon.ui").nav_file(4) end, silent)

