local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm(( select = true )),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.setup()
