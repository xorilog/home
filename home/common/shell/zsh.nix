{
  config,
  lib,
  pkgs,
  ...
}:
let
  shellConfig = import ./shell.nix { inherit config lib pkgs; };
in
{
  home.packages = with pkgs; [
    zsh-syntax-highlighting
    nix-zsh-completions
  ];

  home.file."${config.programs.zsh.dotDir}/completion.zsh".source = ./zsh/completion.zsh;
  home.file."${config.programs.zsh.dotDir}/prompt.zsh".source = ./zsh/prompt.zsh;
  home.file."${config.programs.zsh.dotDir}/functions/j".source = ./zsh/j;

  programs = {
    direnv.enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";
    # xophe
    #defaultKeymap = "emacs";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.xdg.dataHome}/zsh_history";
      save = shellConfig.historySize;
      share = true;
    };
    envExtra = shellConfig.env;
    initContent = ''
      # c.f. https://wiki.gnupg.org/AgentForwarding
      # gpgconf --create-socketdir is only needed on Linux (creates /run/user/<uid>/gnupg)
      # On macOS, sockets are in ~/.gnupg by default
      [[ "$(uname)" == "Linux" ]] && gpgconf --create-socketdir &!
      path+="${config.programs.zsh.dotDir}/functions"
      fpath+="$HOME/.nix-profile/share/zsh/site-functions"
      fpath+="${config.programs.zsh.dotDir}/functions"
      for func (${config.programs.zsh.dotDir}/functions) autoload -U $func/*(x:t)
      autoload -Uz select-word-style; select-word-style bash
      if [ -e ''${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ''${HOME}/.nix-profile/etc/profile.d/nix.sh; fi
      #if [ -n "$INSIDE_EMACS" ]; then
      #  chpwd() { print -P "\033AnSiTc %d" }
      #  print -P "\033AnSiTu %n"
      #  print -P "\033AnSiTc %d"
      #fi
      if [[ "$TERM" == "dumb" || "$TERM" == "emacs" ]]
      then
        TERM=eterm-color
        unsetopt zle
        unsetopt prompt_cr
        unsetopt prompt_subst
        unfunction precmd
        unfunction preexec
        PS1='$ '
        return
      fi
      # make sure navigation using emacs keybindings works on all non-alphanumerics
      # syntax highlighting
      source ${config.programs.zsh.dotDir}/plugins/zsh-nix-shell/nix-shell.plugin.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
      ZSH_HIGHLIGHT_PATTERNS+=('rm -fR *' 'fg=white,bold,bg=red')
      ZSH_HIGHLIGHT_PATTERNS+=('rm -fr *' 'fg=white,bold,bg=red')
      source ${config.programs.zsh.dotDir}/completion.zsh
      source ${config.programs.zsh.dotDir}/plugins/powerlevel10k/powerlevel10k.zsh-theme
      source ${config.programs.zsh.dotDir}/prompt.zsh
      setopt hist_ignore_space
      alias -g L="|less"
      alias -g EEL=' 2>&1 | less'
      alias -g GB='`git rev-parse --abbrev-ref HEAD`'
      alias -g GR='`git rev-parse --show-toplevel`'
      alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
      alias -s org=emacs
      (( $+commands[jq] )) && alias -g MJ="| jq -C '.'"  || alias -g MJ="| ${pkgs.python3}/bin/python -mjson.tool"
      (( $+functions[zshz] )) && compdef _zshz j
    '';
    loginExtra = ''
      export GOPATH=${config.home.homeDirectory}
    '';
    profileExtra = ''
      if [ -e ''${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ''${HOME}/.nix-profile/etc/profile.d/nix.sh; fi
    '';
    localVariables = {
      EMOJI_CLI_KEYBIND = "^n";
      EMOJI_CLI_USE_EMOJI = "yes";
      ZSH_HIGHLIGHT_HIGHLIGHTERS = [
        "main"
        "brackets"
        "pattern"
      ];
    };
    sessionVariables = {
      RPROMPT = "";
    };
    plugins = [
      {
        name = "emoji-cli";
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "emoji-cli";
          rev = "26e2d67d566bfcc741891c8e063a00e0674abc92";
          sha256 = "0n88w4k5vaz1iyikpmlzdrrkxmfn91x5s4q405k1fxargr1w6bmx";
        };
      }
      {
        name = "zsh-z";
        src = pkgs.fetchFromGitHub {
          owner = "agkozak";
          repo = "zsh-z";
          rev = "aaafebcd97424c570ee247e2aeb3da30444299cd";
          sha256 = "sha256-9Wr4uZLk2CvINJilg4o72x0NEAl043lP30D3YnHk+ZA=";
        };
      }
      {
        name = "async";
        src = pkgs.fetchFromGitHub {
          owner = "mafredri";
          repo = "zsh-async";
          rev = "v1.8.5";
          sha256 = "sha256-mpXT3Hoz0ptVOgFMBCuJa0EPkqP4wZLvr81+1uHDlCc=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "922eee0706acb111e9678ac62ee77801941d6df2";
          sha256 = "04skzxv8j06f1snsx62qnca5f2183w0wfs5kz78rs8hkcyd6g89w";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.20.0";
          sha256 = "sha256-ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
        };
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];
    shellAliases = shellConfig.aliases;
  };
}
