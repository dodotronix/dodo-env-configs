vim.g.mapleader = " "
vim.g.localleader = "\\"
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
vim.o.runtimepath = vim.o.runtimepath
vim.g.netrw_local_delete_recursive=1

vim.g.himalaya_folder_picker = 'telescope'
vim.g.himalaya_executable = "/usr/bin/himalaya"

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
vim.opt.clipboard = 'unnamedplus'

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.completeopt={"menu", "menuone", "noselect"}
vim.lsp.set_log_level("debug")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('plugins')
