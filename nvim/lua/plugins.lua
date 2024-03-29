
return require('packer').startup(function(use)

--use 'morhetz/gruvb
use 'wbthomason/packer.nvim'
use {'folke/tokyonight.nvim', branch = 'main' }
use 'tpope/vim-fugitive'
use {'lewis6991/gitsigns.nvim', branch = 'main' }
use {'rmagatti/auto-session'}
use 'vim-utils/vim-man'
use 'mbbill/undotree'
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  tag = 'nightly' -- optional, updated every week. (see issue #1193)
}
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use 'neovim/nvim-lspconfig'
use {'hrsh7th/cmp-vsnip', branch = 'main' }
use 'hrsh7th/vim-vsnip'
use {
  'VonHeikemen/lsp-zero.nvim',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  }
}
use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'nvim-treesitter/nvim-treesitter-context'
use 'mfussenegger/nvim-dap'
use 'christoomey/vim-tmux-navigator'
use 'romgrk/barbar.nvim'

use 'nvim-tree/nvim-web-devicons'

end)
