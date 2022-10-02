return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use 'EdenEast/nightfox.nvim'
	use 'nvim-lualine/lualine.nvim'
	use 'soywod/himalaya'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-treesitter/nvim-treesitter'
	use 'ThePrimeagen/harpoon'
	use 'ThePrimeagen/vim-be-good'
	use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
	use { "nvim-neorg/neorg", requires = 'nvim-lua/plenary.nvim' }
end)

