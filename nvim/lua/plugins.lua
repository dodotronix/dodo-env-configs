require("lazy").setup({
  'folke/which-key.nvim',
  { 'folke/neoconf.nvim', cmd = 'Neoconf' },
  'EdenEast/nightfox.nvim',
  'nvim-lualine/lualine.nvim',
  'fedepujol/move.nvim',
  'soywod/himalaya',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-context',
  'ThePrimeagen/harpoon',
  'ThePrimeagen/vim-be-good',
  'ThePrimeagen/git-worktree.nvim',
  'luukvbaal/nnn.nvim',
  'b3nj5m1n/kommentary',
  'kdheepak/lazygit.nvim',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  {
      -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
          -- Automatically install LSPs to stdpath for neovim
          { 'williamboman/mason.nvim', config = true },
          'williamboman/mason-lspconfig.nvim',

          -- Useful status updates for LSP
          -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
          { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

          -- Additional lua configuration, makes nvim stuff amazing!
          'folke/neodev.nvim',
      },
  },

  {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = {
          -- Snippet Engine & its associated nvim-cmp source
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',
          -- Adds LSP completion capabilities
          'hrsh7th/cmp-nvim-lsp',
          -- Adds a number of user-friendly snippets
          'rafamadriz/friendly-snippets' 
      },
  },

  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-cmdline',
  'onsails/lspkind.nvim',
  'lewis6991/gitsigns.nvim',
  'p00f/nvim-ts-rainbow',
  'nvim-lua/plenary.nvim',
  { 'nvim-telescope/telescope.nvim', tag = '0.1.0' },
  { "nvim-neorg/neorg", build=":Neorg sync-parsers"},

  -- plugins development
  {dir='/home/dodotronix/projects/neoSVmode'}
  -- 'dodotronix/neoSVmode'
})
