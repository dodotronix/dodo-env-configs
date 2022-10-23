
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

vim.o.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.completeopt={"menu", "menuone", "noselect"}

require('plugins')
