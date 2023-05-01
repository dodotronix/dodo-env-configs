require('nnn').setup({picker = {
		cmd = "nnn -PpG",
		style = { width = 0.9,     -- percentage relative to terminal size when < 1, absolute otherwise
			  height = 0.8,    -- ^
			  xoffset = 0.5,   -- ^
			  yoffset = 0.5,   -- ^ 
			  border = "rounded" }
	},
	offset = true,      -- whether or not to write position offset to tmpfile(for use in preview-tui)
})
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>pv', ':NnnPicker %:p:h<<CR>', opts)
