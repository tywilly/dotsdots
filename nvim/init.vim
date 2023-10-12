syntax on

set updatetime=100

set noerrorbells
" set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number relativenumber
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set hlsearch

set scrolloff=10

set list listchars=tab:▶▶,trail:·,extends:>

set colorcolumn=90
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Load plugins
lua require('plugins')

colorscheme tokyonight
set background=dark

let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_banner = 0
let g:netrw_winsize = 25

set completeopt=menu,menuone,noselect

" Load lualine
luafile ~/.config/nvim/lua/powerline.lua

" Load Tree sitter config
luafile ~/.config/nvim/lua/treesitter.lua

" Load LSP configs
luafile ~/.config/nvim/lua/lsp.lua

" Load Git configs
luafile ~/.config/nvim/lua/git.lua

nnoremap <leader>Gbl :Gitsigns toggle_current_line_blame<CR>

" Load autosession stuff
luafile ~/.config/nvim/lua/autosess.lua

" General settings
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ps <cmd>Telescope live_grep<CR>
nnoremap <leader>Q :wincmd q<CR>
nnoremap <silent> <leader>\" :split<CR>
nnoremap <silent> <leader>\| :vsplit<CR>
nnoremap <leader>pf <cmd>Telescope find_files<CR>
nnoremap <leader>bb <cmd>Telescope buffers<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bf <cmd>lua vim.lsp.buf.format()<CR>
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader><Tab> :tabn<CR>
nnoremap <silent> <leader><S-Tab> :tabp<CR>
nnoremap <silent> <leader>nt :tab split<CR>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" NVIM tree settings

luafile ~/.config/nvim/lua/nvimtree.lua

" Open when directory is provided
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

nnoremap <leader>pv :NvimTreeToggle<CR>

" Tab settings
" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>

" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>

" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>

" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
" Restore buffer
nnoremap <silent>    <A-s-c> <Cmd>BufferRestore<CR>

" Magic buffer-picking mode
nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
nnoremap <silent> <C-p>    <Cmd>BufferPickDelete<CR>

" LSP settings
nnoremap <silent> <leader>s <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-s> <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <silent> <C-s> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>gd <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>gf <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>gF <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>gr <cmd>Telescope lsp_references<CR>
nnoremap <silent> <leader>ge <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>gR <cmd>lua vim.lsp.buf.rename()<CR>
