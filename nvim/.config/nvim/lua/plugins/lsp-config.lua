--# selene: allow(mixed_table)
return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport =
                true
            capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
                require("blink.cmp").get_lsp_capabilities()
            )
            capabilities.offsetEncoding = { "utf-16" }

            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
}
