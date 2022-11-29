
return require('packer').startup(function(use)

--use 'morhetz/gruvbox'
use 'wbthomason/packer.nvim'
use {'folke/tokyonight.nvim', branch = 'main' }
use 'jremmen/vim-ripgrep'
use 'tpope/vim-fugitive'
use {'lewis6991/gitsigns.nvim', branch = 'main' }
use {'rmagatti/auto-session', branch = 'main' }
use 'vim-utils/vim-man'
use 'lyuts/vim-rtags'
use 'mbbill/undotree'
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
use 'scrooloose/nerdtree'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use 'neovim/nvim-lspconfig'
use {'williamboman/nvim-lsp-installer', branch = 'main'}
use {'hrsh7th/cmp-nvim-lsp', branch = 'main' }
use {'hrsh7th/cmp-path', branch = 'main' }
use {'hrsh7th/nvim-cmp', branch = 'main' }
use {'hrsh7th/cmp-vsnip', branch = 'main' }
use 'hrsh7th/vim-vsnip'
use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'nvim-treesitter/nvim-treesitter-context'

end)
