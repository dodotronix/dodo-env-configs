return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use 'EdenEast/nightfox.nvim'
	use 'nvim-lualine/lualine.nvim'
	use 'fedepujol/move.nvim'
	use 'soywod/himalaya'
	use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'
	use 'ThePrimeagen/harpoon'
	use 'ThePrimeagen/vim-be-good'
    use 'ThePrimeagen/git-worktree.nvim'
	use 'luukvbaal/nnn.nvim'
	use 'b3nj5m1n/kommentary'
	use 'neovim/nvim-lspconfig'
    use 'kdheepak/lazygit.nvim'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
    use 'L3MON4D3/LuaSnip'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-cmdline'
	use 'onsails/lspkind.nvim'
	use 'saadparwaiz1/cmp_luasnip'
    use 'lewis6991/gitsigns.nvim'
    use 'p00f/nvim-ts-rainbow'
    use 'nvim-lua/plenary.nvim'
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
	use { "nvim-neorg/neorg", requires = 'nvim-lua/plenary.nvim' }
	-- plugins development
	-- use '/home/dodotronix/projects/neoSVmode'
    use 'dodotronix/neoSVmode'
end)

