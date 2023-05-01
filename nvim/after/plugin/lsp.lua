local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local config_on_attach = function ()
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, {})
end

require('lspconfig')["clangd"].setup{
    capabilities = capabilities,
    on_attach = config_on_attach,
}


require('lspconfig')["verible"].setup{
	capabilities = capabilities,
	on_attach = config_on_attach,
    root_dir = function()
        local a = vim.loop.cwd()
        return a
    end,
    -- root_dir = function() return vim.loop.cwd() end
}

require('lspconfig')['pyright'].setup{
	capabilities = capabilities,
	on_attach = config_on_attach,
	flags = lsp_flags,
}

require('lspconfig')['lua_ls'].setup{
	capabilities = capabilities,
	on_attach = config_on_attach,
	flags = lsp_flags,
	settings = {
		Lua = {
			diagnostics = { globals = {  'vim' }, },
            workspace = {
                library = {
                    vim.api.nvim_get_runtime_file("", true),
                    [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            }
		},
	}
}

