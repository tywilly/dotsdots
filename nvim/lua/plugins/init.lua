return {
	-- add dracula
  	{ "Mofiqul/dracula.nvim",
	config = function()
		vim.cmd[[colorscheme dracula]]
	end,
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

  {
    "folke/which-key.nvim",
    lazy = false,
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      return {}
    end,
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
    },
  },

-- lsp stuff
{
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        {"neovim/nvim-lspconfig", config = function() require("config.lspconfig").defaults() end,}
    },
},
-- Terminal
  {'akinsho/toggleterm.nvim', version = "*", config = true}
}
