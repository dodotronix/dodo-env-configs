require("lazy").setup({
    --'folke/which-key.nvim',
    { 'folke/neoconf.nvim', cmd = 'Neoconf' },
    'EdenEast/nightfox.nvim',
    'nvim-lualine/lualine.nvim',
    'fedepujol/move.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-context',
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
    {
        "nvim-neorg/neorg",
        lazy = false,
        version = "*",
    },
  'ThePrimeagen/vim-be-good',
  'b3nj5m1n/kommentary',
  'kdheepak/lazygit.nvim',

  { 'nvim-telescope/telescope.nvim', tag = '0.1.4',
        dependencies = {'nvim-lua/plenary.nvim'}},

    -- {'Exafunction/codeium.vim', event = 'BufEnter'},

    -- plugins development
    -- {dir='/home/dodotronix/projects/neoSVmode'}
    -- 'dodotronix/neoSVmode'
})
