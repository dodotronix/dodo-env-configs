
vim.g.mapleader = " "
vim.g.localleader = "\\"
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
vim.o.runtimepath = vim.o.runtimepath..',~/.local/share/nvim/site/pack/packer/start/himalaya/vim'
vim.g.netrw_local_delete_recursive=1

vim.opt.number = true
vim.opt.title = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.o.noswapfile = true

require('plugins')
