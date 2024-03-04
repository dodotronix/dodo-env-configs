require("mason").setup()
local mason_lspconfig = require('mason-lspconfig')

local servers = {verible = {}, clangd = {}}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(client, bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then
            return ']c'
        end
        vim.schedule(function()
            gs.next_hunk()
        end)
        return '<Ignore>'
    end, { expr = true, desc = 'Jump to next hunk' })

    map({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then
            return '[c'
        end
        vim.schedule(function()
            gs.prev_hunk()
        end)
        return '<Ignore>'
    end, { expr = true, desc = 'Jump to previous hunk' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'stage git hunk' })
    map('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'reset git hunk' })
    -- normal mode
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
    map('n', '<leader>hb', function()
        gs.blame_line { full = false }
    end, { desc = 'git blame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>hD', function()
        gs.diffthis '~'
    end, { desc = 'git diff against last commit' })

    -- lsp control
    map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
    map('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
    map('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = '[G]oto [I]mplementation' })
    map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
    map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
    map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, { desc = 'Type [D]efinition' })

    map('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

    map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

    map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })

    map('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,

}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

require("neodev").setup()
