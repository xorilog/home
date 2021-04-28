{ config, pkgs, ... }:

{
  imports = [
    ../../modules/shells/bash.nix
    ../../modules/shells/zsh.nix
    ../../modules/tools/direnv.nix
    ../../modules/tools/fzf.nix
    ../../modules/tools/gopass.nix
    ../../modules/tools/htop.nix
    ../../modules/tools/tmux.nix
    ../../modules/tools/xdg.nix
  ];

  home = {
    stateVersion = "21.03";
    packages = with pkgs; [
      zoom-us
      google-chrome
      # Common tools
      htop
      iftop
      tmux
      jq
      wget

      # 1password
      _1password

      # trying gopass
      # pass

      # Infrastructure
      #aws-vault
      #awscli2
      # Authenticator is in version 0.4.0 and we need to use version 0.5 at least
      #aws-iam-authenticator
      kubectl
      docker-compose
      terragrunt
      terraform_0_14
      terraform-docs

      # Communication
      slack
      discord
      mattermost-desktop

      # Editor / Code / Dev
      rust-analyzer
      yaml-language-server
      solargraph # ruby language server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.typescript-language-server
      nodejs
      ctags

      # Real editor
      vscode
      yed

      # Dev tools (to move elsewhere)
      hub

      # languages
      #python3

      # Go
      #gcc
      #gopls
      #jetbrains.goland

      # Graphical
      xclip
      shutter

      # Build
      #neovim-unwrapped # uses an overlay to build from master (i want neovim 0.5.0 version)
      # GPG Yubikey etc
      yubico-piv-tool
      yubikey-personalization
      yubioath-desktop
      yubikey-manager

      # Gnupg
      #gnupg
      #pinentry # dialog

      # System information
      inxi
    ];
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    }
  '';
  xdg.configFile."nr/default" = {
    text = builtins.toJSON [
      { cmd = "ncdu"; }
      { cmd = "sshfs"; }
      { cmd = "lspci"; pkg = "pciutils"; }
      { cmd = "lsusb"; pkg = "usbutils"; }
      { cmd = "9"; pkg = "plan9port"; }
      { cmd = "wakeonlan"; pkg = "python36Packages.wakeonlan"; }
    ];
    onChange = "${pkgs.my.nr}/bin/nr default";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ python-language-server ]);
    extraPackages = with pkgs; [ git ];
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-rust-analyzer
      coc-solargraph
      coc-fzf
      fzfWrapper
      fzf-vim
      gruvbox
      lightline-vim
      LanguageClient-neovim
      nvim-lspconfig
      tagbar
      ultisnips
      vim-go
      vim-repeat
      vim-surround
      vim-trailing-whitespace
      vim-multiple-cursors
      vim-fugitive
      vim-rhubarb
      vim-gitgutter
      vim-nix
      vim-lsp
    ];
    extraConfig = ''
      "" General Config
      set nocompatible            " Disable compatibility to old-time vi
      set noswapfile              " No swap files
      set showmatch               " Show matching brackets.
      set mouse=v                 " middle-click paste with mouse
      set tabstop=2               " number of columns occupied by a tab character
      set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
      set shiftwidth=2            " width for autoindents
      set expandtab               " converts tabs to white space
      set autoindent              " indent a new line the same amount as the line just typed
      set number                  " add line numbers
      set relativenumber          " relative line numbers
      set wildmode=longest,list   " get bash-like tab completions
      set cc=120                  " set an 120 column border for good coding style
      set laststatus=2

      colorscheme gruvbox
      let mapleader=","
      let localleader=",,"


      filetype plugin on
      filetype indent on
      syntax on

      set noshowmode
      let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ }
      let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]

      " toggle spelling
      nnoremap <leader>s :set invspell<CR>

      " Split navigation
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>

      " FZF shortcuts
      nmap <c-p> :Files<CR>
      nmap ; :Buffers<CR>
      nmap <Leader>f :Ag<space><c-r>=expand("<cword>")<cr><CR>

      " Misc
      nmap <Leader>w :FixWhitespace<CR>
      nmap <F12> :TagbarToggle<CR>

      " Neovim LSP setup
      lua <<EOF
        require'lspconfig'.gopls.setup{}
        require'lspconfig'.dockerls.setup{}
        require'lspconfig'.bashls.setup{}
        require'lspconfig'.solargraph.setup{
          filetypes = { "ruby", "rb" }
        }
        require'lspconfig'.tsserver.setup{}
        require'lspconfig'.yamlls.setup{
          filetypes = { "yaml", "yml" }
        }
        require'lspconfig'.rust_analyzer.setup{}
      EOF

      autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc
      autocmd Filetype rs setlocal omnifunc=v:lua.vim.lsp.omnifunc
      autocmd Filetype sh setlocal omnifunc=v:lua.vim.lsp.omnifunc
      autocmd Filetype rb setlocal omnifunc=v:lua.vim.lsp.omnifunc
      autocmd Filetype js setlocal omnifunc=v:lua.vim.lsp.omnifunc

      autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
      autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)

      " LSP shortcuts
      nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> <leader>D <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> <leader>R <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <silent> <leader>F <cmd>lua vim.lsp.buf.formatting()<CR>
      nnoremap <silent> <leader>cs <cmd>lua vim.lsp.buf.incoming_calls()<CR>
      nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> <leader>q :cclose<CR>

    '';

    # configure = {
    #   plug.plugins = with pkgs.vimPlugins; [
    #     coc-nvim
    #     coc-rust-analyzer
    #     coc-solargraph
    #     coc-fzf
    #     fzfWrapper
    #     fzf-vim
    #     gruvbox
    #     lightline-vim
    #     LanguageClient-neovim
    #     nvim-lspconfig
    #     tagbar
    #     ultisnips
    #     vim-go
    #     vim-repeat
    #     vim-surround
    #     vim-trailing-whitespace
    #     vim-multiple-cursors
    #     vim-fugitive
    #     vim-rhubarb
    #     vim-gitgutter
    #     vim-nix
    #     vim-lsp
    #   ];
    #   customRC = ''
    #     set nocompatible            " Disable compatibility to old-time vi
    #     set noswapfile              " No swap files
    #     set showmatch               " Show matching brackets.
    #     set mouse=v                 " middle-click paste with mouse
    #     set tabstop=2               " number of columns occupied by a tab character
    #     set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
    #     set shiftwidth=2            " width for autoindents
    #     set expandtab               " converts tabs to white space
    #     set autoindent              " indent a new line the same amount as the line just typed
    #     set number                  " add line numbers
    #     set relativenumber          " relative line numbers
    #     set wildmode=longest,list   " get bash-like tab completions
    #     set cc=120                  " set an 120 column border for good coding style
    #     set laststatus=2

    #     colorscheme gruvbox
    #     let mapleader=","
    #     let localleader=",,"


    #     filetype plugin on
    #     filetype indent on
    #     syntax on

    #     set noshowmode
    #     let g:lightline = {
    #           \ 'colorscheme': 'jellybeans',
    #           \ }
    #     let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]

    #     " toggle spelling
    #     nnoremap <leader>s :set invspell<CR>

    #     " Split navigation
    #     nnoremap <C-J> <C-W><C-J>
    #     nnoremap <C-K> <C-W><C-K>
    #     nnoremap <C-L> <C-W><C-L>
    #     nnoremap <C-H> <C-W><C-H>

    #     " FZF shortcuts
    #     nmap <c-p> :Files<CR>
    #     nmap ; :Buffers<CR>
    #     nmap <Leader>f :Ag<space><c-r>=expand("<cword>")<cr><CR>

    #     " Misc
    #     nmap <Leader>w :FixWhitespace<CR>
    #     nmap <F12> :TagbarToggle<CR>

    #     " Neovim LSP setup
    #     lua <<EOF
    #       require'lspconfig'.gopls.setup{}
    #       require'lspconfig'.dockerls.setup{}
    #       require'lspconfig'.bashls.setup{}
    #       require'lspconfig'.solargraph.setup{
    #         filetypes = { "ruby", "rb" }
    #       }
    #       require'lspconfig'.tsserver.setup{}
    #       require'lspconfig'.yamlls.setup{
    #         filetypes = { "yaml", "yml" }
    #       }
    #       require'lspconfig'.rust_analyzer.setup{}
    #     EOF

    #     autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc
    #     autocmd Filetype rs setlocal omnifunc=v:lua.vim.lsp.omnifunc
    #     autocmd Filetype sh setlocal omnifunc=v:lua.vim.lsp.omnifunc
    #     autocmd Filetype rb setlocal omnifunc=v:lua.vim.lsp.omnifunc
    #     autocmd Filetype js setlocal omnifunc=v:lua.vim.lsp.omnifunc

    #     autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
    #     autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)

    #     " LSP shortcuts
    #     nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
    #     nnoremap <silent> <leader>D <cmd>lua vim.lsp.buf.declaration()<CR>
    #     nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.implementation()<CR>
    #     nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.signature_help()<CR>
    #     nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.references()<CR>
    #     nnoremap <silent> <leader>R <cmd>lua vim.lsp.buf.rename()<CR>
    #     nnoremap <silent> <leader>F <cmd>lua vim.lsp.buf.formatting()<CR>
    #     nnoremap <silent> <leader>cs <cmd>lua vim.lsp.buf.incoming_calls()<CR>
    #     nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
    #     nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    #     nnoremap <silent> <leader>q :cclose<CR>

    #   '';
    # };
  };

  programs.gpg.enable = true;

  programs.gh = {
    enable = true;
    aliases = {
      co = "pr checkout";
    };
    editor = "nvim";
    gitProtocol = "ssh";
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "christophe.boucharlat";
    userEmail = "christophe.boucharlat@gmail.com";

    signing = {
      #gpgPath = "/usr/bin/gpg";
      #gpgPath = "/home/xophe/.nix-profile/bin/gpg";
      key = "B151572DE8FADB71";
      signByDefault = true;
    };

    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      type = "cat-file -t";
      dump = "cat-file -p";
      pullr = "pull --rebase --prune";
      unadd = "reset HEAD";
    };

    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
      };

      diff = {
        renames = "copies";
      };

      pull = {
        rebase = true;
      };

      push = {
        default = "simple";
        recurseSubmodules = "check";
      };

      merge = {
        log = true;
        ff = "only";
        commit = "no";
      };

      rebase.autosquash = true;

      # fsck section
      transfer.fsckobjects = false;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;

      apply.whitespace = "fix";

      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };

      "color.branch" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      "color.diff" = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red";
        new = "green";
      };

      "color.status" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      github.user = "xorilog";

      "filter \"lfs\"" = {
        clean = "git lfs clean %f";
        smudge = "git lfs smudge %f";
        required = true;
      };
      url = {
        "git@github.com:" = {
          insteadOf = "git://github.com/";
          "insteadOf " = "http://github.com/";
          "insteadOf  " = "https://github.com/";
        };
        "git@gitlab.com:" = {
          insteadOf = "git://gitlab.com/";
          "insteadOf " = "http://gitlab.com/";
          "insteadOf  " = "https://gitlab.com/";
        };
        "git@gitlab.edf-sf.com:" = {
          insteadOf = "git://gitlab.edf-sf.com/";
          "insteadOf " = "http://gitlab.edf-sf.com/";
          "insteadOf  " = "https://gitlab.edf-sf.com/";
        };
      };
    };

    includes = [
      {
        path = "${config.xdg.configHome}/git/config.d/edf-sf.gitconfig";
        condition = "gitdir:${config.home.homeDirectory}/src/gitlab.edf-sf.com/";
      }
      {
        path = "${config.xdg.configHome}/git/config.d/edf-sf.gitconfig";
        condition = "gitdir:${config.home.homeDirectory}/go/src/gitlab.edf-sf.com/";
      }
    ];
  };
  xdg.configFile."git/config.d/edf-sf.gitconfig".source = ./git/edf-sf.gitconfig;

  programs.vim = {
    enable = true;
  };

  #programs.bash.enable = true;

  #programs.go.enable = true;
  # Always set GOROOT
  #config.environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };
}
