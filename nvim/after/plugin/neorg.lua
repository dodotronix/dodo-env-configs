vim.opt.conceallevel = 3
require('neorg').setup ({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
            config = { -- We added a `config` table!
                icon_preset = "varied", -- And we set our option here.
            },
        },       ["core.dirman"] = {
            config = { 
                workspaces = {
                    me = "~/projects/records/me"
                },
                default_workspace = "me"
            }, 
        },
    },
    -- Set custom logger settings
    -- logger = { level = "trace" },
})

-- require 'nvim-treesitter.configs'.setup {
-- 	ensure_installed = { 'norg' },
-- 	highlight = { enable = true, }
-- }

