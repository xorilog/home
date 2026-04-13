{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gist
    git-lfs
    git-review

    my.prm

    #hub
    #gitAndTools.gh

  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [
        "github.com"
        "gist.github.com"
      ];
    };
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    signing = {
      #gpgPath = "/usr/bin/gpg";
      #gpgPath = "/home/xophe/.nix-profile/bin/gpg";
      key = "B151572DE8FADB71";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "christophe.boucharlat";
        email = "christophe.boucharlat@gmail.com";
      };

      # Changed from aliases to alias as it was not working on Darwin
      # TODO: validate if it is ok on Linux as well.
      alias = {
        co = "checkout";
        ci = "commit --signoff";
        st = "status";
        br = "branch";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        type = "cat-file -t";
        dump = "cat-file -p";
        pullr = "pull --rebase --prune";
        unadd = "reset HEAD";
      };

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
      credential = {
        #"https://github.com" = {
        #  helper = "!${pkgs.gh}/bin/gh auth git-credential";
        #};
        #"https://gist.github.com" = {
        #  helper = "!${pkgs.gh}/bin/gh auth git-credential";
        #};
        "https://gitlab.com" = {
          helper = "!${pkgs.glab}/bin/glab auth git-credential";
        };
      };

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
      };
    };

    ignores = [
      # Emacs
      "*~"
      "*.*~"
      "\\#*"
      ".\\#*"
      # Vim
      "*.swp"
      ".*.sw[a-z]"
      "*.un~"
      "Session.vim"
      ".netrwhist"
      # Tags
      "TAGS"
      "!TAGS/"
      "tags"
      "!tags/"
      # Logs
      "*.log"
      "*.cache"
      # OS
      ".DS_Store"
      ".DS_Store?"
      ".CFUserTextEncoding"
      ".Trash"
      ".Xauthority"
      "thumbs.db"
      "Icon?"
      "Thumbs.db"
      ".cache"
      ".pid"
      ".sock"
      # Code
      ".svn"
      ".git"
      ".swp"
      ".idea"
      ".*.swp"
      ".tags"
      ".sass-cache"
      "tmp"
      ".codekit-cache"
      "config.codekit"
      # Compiled
      "*.class"
      "*.exe"
      "*.o"
      "*.so"
      "*.dll"
      "*.pyc"
    ];

    includes = [
      {
        path = "${config.xdg.configHome}/git/config.d/ags.gitconfig";
        condition = "hasconfig:remote.*.url:git@gitlab.com:agregio_group/**";
      }
      {
        path = "${config.xdg.configHome}/git/config.d/ags.gitconfig";
        condition = "hasconfig:remote.*.url:git@github.com:agregio-solutions/**";
      }
      {
        path = "${config.xdg.configHome}/git/config.d/ags.gitconfig";
        condition = "gitdir:${config.home.homeDirectory}/src/gitlab.com/agregio_group/";
      }
    ];
  };
  xdg.configFile."git/config.d/ags.gitconfig".source = ./git-extra-config/ags.gitconfig;
}
