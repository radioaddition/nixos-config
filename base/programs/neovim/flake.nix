{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = {nixpkgs, nvf, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    nvp = inputs.nixneovimplugins.packages.${system};
    #pkgs = import nixpkgs {
    #  inherit system;
    #  overlays = [ inputs.nixneovimplugins.overlays.default ];
    #};
    inherit inputs;
    configModule = {

      config.vim = {
        viAlias = true;
        vimAlias = true;
        lsp = {
          enable = true;
        };
	visuals.nvim-web-devicons.enable = true;

	fzf-lua = {
	  enable = true;
	  profile = "fzf-vim";
	};

	languages = {
	  enableLSP = true;
	  nix = {
	    enable = true;
	    format.enable = false;
	    format.type = "nixfmt";
	    lsp = {
	      enable = true;
	      # Enable below when [458](https://github.com/NotAShelf/nvf/pull/458) gets merged
	      #package = pkgs.nixd;
	      #server = "nixd";
	    };
	    treesitter.enable = true;
	  };
	};

	statusline.lualine.enable = true;

	extraPlugins = {

          sort.package = nvp.sort-nvim;

	  adwaita = {
	    package = nvp.adwaita-nvim;
	    setup = ''
	      vim.g.adwaita_transparent = true
              vim.cmd([[silent! colorscheme adwaita]])
            '';
	  };

	  nui.package = nvp.nui-nvim;

	  just = {
	    package = nvp.tree-sitter-just;
	    #package = nvp.just-nvim;
	    #setup = ''
            #  require("nvim-treesitter.configs").setup({
            #    highlight = {
            #      enable = true,
            #      disable = { "just" },
            #    },
            #  })
	    #'';
	  };

	  fine-cmdline = {
	    package = nvp.fine-cmdline-nvim;
	    setup = "vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})"; # Map ":"
	    #setup = "vim.api.nvim_set_keymap('n', '<CR>', '<cmd>FineCmdline<CR>', {noremap = true})"; # Map Enter
	  };

	  vim-easy-align.package = nvp.vim-easy-align;

	};

	luaConfigPost = ''
          vim.opt.number = true
          require("lualine").setup({options = {theme = "adwaita"}})
          vim.opt.relativenumber = true
          vim.opt.cursorline = true
          vim.opt.cursorcolumn = true
          vim.opt.lazyredraw = true
          vim.opt.ignorecase = true
          vim.opt.smartcase = true
          vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
          vim.opt.linebreak = true
          vim.opt.scrolloff = 5
          vim.cmd([[let g:adwaita_transparent = v:true]])
          vim.cmd([[silent! colorscheme adwaita]])
          vim.cmd([[au InsertEnter * hi CursorLine gui=underline cterm=underline]])
          vim.cmd([[au InsertLeave * hi CursorLine gui=none cterm=none guibg=Grey20]])
          vim.cmd([[au InsertEnter * hi CursorColumn gui=none cterm=none guibg=transparent]])
          vim.cmd([[au InsertLeave * hi CursorColumn gui=none cterm=none guibg=Grey20]])
          vim.cmd([[nnoremap <CR> <cmd>FineCmdline<CR>]])
          vim.opt.showmode = false
	'';
      };
    };

    customNeovim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ configModule ];
    };
  in {
    packages.${system}.neovim = customNeovim.neovim;
    default = customNeovim.neovim;
  };
}
