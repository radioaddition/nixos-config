{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs =
    {
      self,
      nixpkgs,
      nvf,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      nvp = inputs.nixneovimplugins.packages.${system};
      inherit inputs;
      configModule = {

        config.vim = {
          viAlias = true;
          vimAlias = true;
          lsp = {
            enable = true;
            lspconfig.enable = true;
          };
          visuals.nvim-web-devicons.enable = true;

          fzf-lua = {
            enable = true;
            profile = "fzf-vim";
          };

          languages = {
            enableLSP = true;
            enableTreesitter = true;
            # Enable below when [458](https://github.com/NotAShelf/nvf/pull/458) gets merged
            #nix = {
            #  enable = true;
            #  format.enable = false;
            #  format.type = "nixfmt";
            #  lsp = {
            #    enable = true;
            #    #package = pkgs.nixd;
            #    #server = "nixd";
            #  };
            #};
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

            nixd = {
              package = pkgs.nixd;
              setup = "require'lspconfig'.nixd.setup{}";
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
            };

            vim-easy-align.package = nvp.vim-easy-align;

          };

          luaConfigPost = ''
                      -- enable line numbers
                      vim.opt.number = true
                      vim.opt.relativenumber = true

                      -- set neovim theme to adwaita (unsupported by nvf directly)
                      vim.cmd([[let g:adwaita_transparent = v:true]])
                      vim.cmd([[silent! colorscheme adwaita]])

                      -- use adwaita theme for lualine (also unsupported by nvf)
                      require("lualine").setup({options = {theme = "adwaita"}})

                      -- add line and column line at cursor
                      vim.opt.cursorline = true
                      vim.opt.cursorcolumn = true

                      -- related to above, modify line appearance when in insert mode
                      vim.cmd([[au InsertEnter * hi CursorLine gui=underline cterm=underline]])
                      vim.cmd([[au InsertLeave * hi CursorLine gui=none cterm=none guibg=Grey20]])
                      vim.cmd([[au InsertEnter * hi CursorColumn gui=none cterm=none guibg=transparent]])
                      vim.cmd([[au InsertLeave * hi CursorColumn gui=none cterm=none guibg=Grey20]])

                      -- speed up macros
                      vim.opt.lazyredraw = true

                      -- only search case-sensitive if search contains UPPERCASE characters
                      vim.opt.ignorecase = true
                      vim.opt.smartcase = true

                      -- let yank register sync with system clipboard
                      vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

                      -- only break lines at whitespace, don't break in the middle of words
                      vim.opt.linebreak = true

                      -- keep cursor from scrolling to edge of screen
                      vim.opt.scrolloff = 5

                      -- don't show vim mode, since lualine does this for us
                      vim.opt.showmode = false

                      -- enable nixd lsp server, as this is also unsupported by nvf
                      --require'lspconfig'.nixd.setup{}
            	'';
        };
      };

      customNeovim = nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ configModule ];
      };
    in
    {
      packages.${system} = {
        neovim = customNeovim.neovim;
        default = self.packages.${system}.neovim;
      };
    };
}
