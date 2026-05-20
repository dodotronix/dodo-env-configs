P = function (v)
    print(vim.inspect(v))
    return v
end

RELOAD = function (...)
    return require("plenary.reload").reload_module(...)
end

R = function (name)
   RELOAD(name) 
   return require(name)
end

vim.diagnostic.config({
    -- Set to true to see inline messages
    virtual_text = true,

    -- Set to true to see icons in the gutter
    signs = true,

    -- Set to true to underline the problematic text
    underline = true,
})
