vim.opt.conceallevel = 3
require('neorg').setup {
	load = {
		["core.defaults"] = {},
		["core.journal"] = {},
		["core.keybinds"] = {},
		["core.concealer"] = {},
		["core.qol.toc"] = {},
		["core.dirman"] = {
			config = { workspaces = {
				me = "~/projects/records/me",
			},
            default_workspace = "me"} },
		},
		-- Set custom logger settings
		-- logger = { level = "trace" },
	}

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { 'norg' },
	highlight = { enable = true, }
}

