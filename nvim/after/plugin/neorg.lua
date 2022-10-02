require('neorg').setup {
	load = {
		["core.defaults"] = {},
		["core.norg.journal"] = {},
		["core.keybinds"] = {},
		["core.norg.concealer"] = {},
		["core.norg.qol.toc"] = {},
		["core.norg.dirman"] = {
			config = { workspaces = {
				work = "~/projects/vimwiki_record/work",
				home = "~/projects/vimwiki_record/home",
			} } },
		},
		-- Set custom logger settings
		-- logger = { level = "trace" },
	}

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { 'norg' },
	highlight = { enable = true, }
}

