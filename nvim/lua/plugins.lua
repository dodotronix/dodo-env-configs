require("lazy").setup({
    'folke/which-key.nvim',
    { 'folke/neoconf.nvim', cmd = 'Neoconf' },
    'EdenEast/nightfox.nvim',
    'nvim-lualine/lualine.nvim',
    'fedepujol/move.nvim',

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-orgmode/telescope-orgmode.nvim',
            'nvim-orgmode/org-bullets.nvim',
            'lukas-reineke/headlines.nvim',
            'danilshvalov/org-modern.nvim'
        }
    },
    'luukvbaal/nnn.nvim',
    'lewis6991/gitsigns.nvim',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-cmdline',
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
        },
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            'folke/neodev.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'mfussenegger/nvim-dap',
        }
    },
  'ThePrimeagen/vim-be-good',
  'b3nj5m1n/kommentary',
  'kdheepak/lazygit.nvim',

  { 'nvim-telescope/telescope.nvim',
  branch = "master",
  -- tag = '0.1.4',
  dependencies = {'nvim-lua/plenary.nvim'}
  },

  -- {'Exafunction/codeium.vim', event = 'BufEnter'},

  -- plugins development
  -- {dir='/home/dodotronix/projects/neoSVmode'}
  -- 'dodotronix/neoSVmode'
})
