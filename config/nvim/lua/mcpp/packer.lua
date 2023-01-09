-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -------------------- infra ----------------------------------
  use 'ethanholz/nvim-lastplace'
  use 'preservim/nerdcommenter'
  -- file navigator
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
  use('mbbill/undotree')
  -- vim with git
  use('tpope/vim-fugitive')
  -- pair or cursor
  use('jiangmiao/auto-pairs')
  use('tpope/vim-surround')
  use('terryma/vim-multiple-cursors')
  use('easymotion/vim-easymotion')
  use {
      'andymass/vim-matchup',
      setup = function()
          -- may set any options here
          vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end
  }

  -------------------- theme ----------------------------------
  use('shaunsingh/nord.nvim')

  -------------------- lsp ----------------------------------
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

end)
