{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor / Code / Dev
    rust-analyzer
    yaml-language-server
    solargraph # ruby language server
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript-language-server
    nodejs
    ctags
  ];

  programs.vim = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ pkgs.python311Packages.python-lsp-server ]);
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
      " https://github.com/nvim-lua/completion-nvim#changing-completion-confirm-key
      " Tooltip selection section
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
      nmap <Leader>f :Rg<space><c-r>=expand("<cword>")<cr><CR>

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
        require'lspconfig'.ts_ls.setup{}
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
  };
}
