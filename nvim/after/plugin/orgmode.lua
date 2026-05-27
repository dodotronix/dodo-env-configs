
local Menu = require("org-modern.menu")

local org_refile_path = '~/projects/records/refile.org'

require('orgmode').setup({
    ui = {
        menu = {
            handler = function(data)
                Menu:new():open(data)
            end,
        },
    },
    org_agenda_files = '~/projects/records/**/*',
    org_default_notes_file = org_refile_path,
    mappings = {
        org = {
            org_toggle_checkbox = '<leader>x',
        },
    }
})

    require('org-bullets').setup({
        concealcursor = false,
        symbols = {
            checkboxes = {
                todo = { " ", "@org.checkbox.unchecked" },
                half = { " ", "@org.checkbox.halfchecked" },
                done = { " ", "@org.checkbox.checked" },
            },
            headlines = { "◉", "○", "✸", "✿" },
        }
    })



    require("headlines").setup()
    vim.lsp.enable('org')

    vim.api.nvim_create_user_command('OrgDefault', function()
        vim.cmd('edit ' .. org_refile_path)
    end, {})



