{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    inputs.nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = {nixpkgs, nvf, nixneovimplugins, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    overlays = [ nixneovimplugins.overlays.default ];
    configModule = {

      config.vim = {
        theme.enable = true;
        viAlias = true;
        vimAlias = true;
        lsp = {
          enable = true;
        };
	visuals.nvim-web.devicons.enable = true;

	fzf-lua = {
	  enable = true;
	  profile = "fzf-vim";
	};

	languages = {
	  enableLSP = true;
	  nix = {
	    enable = true;
	    format.enable = true;
	    format.type = "nixfmt";
	    lsp = {
	      enable = true;
	      package = pkgs.nixd;
	      server = "nixd";
	    };
	    treesitter.enable = true;
	  };
	};

	statusline.lualine = {
	  enable = true;
	  theme = "adwaita";
	  # If theme option doesn't work
	  #setupOpts = "require(\"lualine\").setup({options.theme = \"adwaita\"})";
	};

	extraPlugins = with pkgs.vimExtraPlugins; {

          sort.package = sort-nvim;

	  adwaita = {
	    package = adwaita-nvim;
	    setup = ''
	      vim.g.adwaita_transparent = true
              vim.cmd([[silent! colorscheme adwaita]])
            '';
	  };

	  nui.package = nui-nvim;

	  just = {
	    package = vim-just;
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
	    package = fine-cmdline-nvim;
	    setup = "vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})"; # Map ":"
	    #setup = "vim.api.nvim_set_keymap('n', '<CR>', '<cmd>FineCmdline<CR>', {noremap = true})"; # Map Enter
	  };

	  vim-easy-align.package = vim-easy-align;

	};

	luaConfigRC = ''
          vim.opt.number = true
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
      modules = [configModule];
    };
  in {
    packages.${system}.neovim = customNeovim.neovim;
  };
}
