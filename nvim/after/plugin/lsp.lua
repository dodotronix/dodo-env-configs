local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['svls'].setup{
    cmd = { "svls", "-d" },
	capabilities = capabilities,
	on_attach = function()
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
		vim.keymap.set("n", "gt", vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
	end,
	flags = lsp_flags,
}
require('lspconfig')['pyright'].setup{
	capabilities = capabilities,
	on_attach = function()
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
	end,
	flags = lsp_flags,
}
require('lspconfig')['sumneko_lua'].setup{
	capabilities = capabilities,
	on_attach = function()
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
	end,
	flags = lsp_flags,
	settings = {
		Lua = {
			diagnostics = { globals = {  'vim' } }
		},
	}
}

