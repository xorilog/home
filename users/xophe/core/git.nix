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
      ci = "commit --signoff";
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
