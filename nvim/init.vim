syntax on

set updatetime=100

set noerrorbells
set tabstop=4 softtabstop=4
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

call plug#begin('~/.local/share/nvim/site/')

Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim', { 'branch': 'main' }
Plug 'rmagatti/auto-session', { 'branch': 'main' }
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer', { 'branch': 'main'}
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-vsnip', { 'branch': 'main' }
Plug 'hrsh7th/vim-vsnip'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-context'

call plug#end()

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_banner = 0
let g:netrw_winsize = 25

set completeopt=menu,menuone,noselect

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
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <leader>Q :wincmd q<CR>
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

" NERDTree settings

" Open when directory is provided
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

nnoremap <leader>pv :NERDTreeToggle<CR>

" Terminal settings
nnoremap <silent> <leader>to :split<CR>:terminal<CR>:horizontal resize 15<CR>
tnoremap <Esc> <C-\><C-n>

" LSP settings
nnoremap <silent> <leader>K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader><C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>gf <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>gF <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ge <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>gR <cmd>lua vim.lsp.buf.rename()<CR>
