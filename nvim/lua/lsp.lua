local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

local mason = require("mason")
local masonlspconfig = require("mason-lspconfig")

mason.setup({})

masonlspconfig.setup({
    ensure_installed = {},
    handlers = {
        lsp.default_setup,
    },
})

-- lsp.skip_server_setup({'jdtls'})

lsp.setup()

