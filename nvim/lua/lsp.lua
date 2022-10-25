
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = true,
        signs = true,
    }
)
-- autocmd CursorHold * lua vim.lsp.diagnostics.show_line_diagnostics()
-- autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
