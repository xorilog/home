{
  config,
  pkgs,
  lib,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  claudeConfigSrc = ../../../dots/config/claude;
in
{
  # Install claude-hooks binary package
  home.packages = [ pkgs.claude-hooks ];

  # Configure Claude Code via XDG config
  xdg.configFile = {
    # Generate settings.json dynamically (no hardcoded paths)
    "claude/settings.json".text = builtins.toJSON {
      hooks = {
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "claude-hooks-initialize-session";
              }
            ];
          }
        ];
        PostToolUse = [
          {
            hooks = [
              {
                type = "command";
                command = "claude-hooks-capture-tool-output";
              }
              {
                type = "command";
                command = "claude-hooks-update-terminal-title";
              }
            ];
          }
        ];
        SessionEnd = [
          {
            hooks = [
              {
                type = "command";
                command = "claude-hooks-save-session";
              }
            ];
          }
        ];
      };
      statusLine = {
        type = "command";
        command = "bash ~/.config/claude/statusline.sh";
      };
      trustedWorkspaces = [
        homeDir
        "${homeDir}/src/github.com/xorilog/home"
      ];
      skills = {
        enabled = true;
        directories = [ "~/.config/claude/skills" ];
      };
      enabledPlugins = {
        "session-manager" = true;
      };
      alwaysThinkingEnabled = true;
    };

    # Statusline script (executable)
    "claude/statusline.sh" = {
      source = "${claudeConfigSrc}/statusline.sh";
      executable = true;
    };

    # Agents
    "claude/agents/architect.md".source = "${claudeConfigSrc}/agents/architect.md";
    "claude/agents/engineer.md".source = "${claudeConfigSrc}/agents/engineer.md";
    "claude/agents/researcher.md".source = "${claudeConfigSrc}/agents/researcher.md";
    "claude/agents/claude-researcher.md".source = "${claudeConfigSrc}/agents/claude-researcher.md";
    "claude/agents/designer.md".source = "${claudeConfigSrc}/agents/designer.md";

    # Hooks directory (placeholder)
    "claude/hooks/.keep".text = "";

    # Plugins
    "claude/plugins/session-manager/plugin.json".source =
      "${claudeConfigSrc}/plugins/session-manager/plugin.json";
    "claude/plugins/session-manager/commands/save-session.md".source =
      "${claudeConfigSrc}/plugins/session-manager/commands/save-session.md";

    # Skills - CORE (all files)
    "claude/skills/CORE" = {
      source = "${claudeConfigSrc}/skills/CORE";
      recursive = true;
    };

    # Skills - Language-specific
    "claude/skills/golang" = {
      source = "${claudeConfigSrc}/skills/golang";
      recursive = true;
    };
    "claude/skills/Nix" = {
      source = "${claudeConfigSrc}/skills/Nix";
      recursive = true;
    };
    "claude/skills/Python" = {
      source = "${claudeConfigSrc}/skills/Python";
      recursive = true;
    };
    "claude/skills/Rust" = {
      source = "${claudeConfigSrc}/skills/Rust";
      recursive = true;
    };

    # Skills - Infrastructure
    "claude/skills/Git" = {
      source = "${claudeConfigSrc}/skills/Git";
      recursive = true;
    };
    "claude/skills/GitHub" = {
      source = "${claudeConfigSrc}/skills/GitHub";
      recursive = true;
    };
    "claude/skills/Docker" = {
      source = "${claudeConfigSrc}/skills/Docker";
      recursive = true;
    };
    "claude/skills/Kubernetes" = {
      source = "${claudeConfigSrc}/skills/Kubernetes";
      recursive = true;
    };

    # Skills - Methodology
    "claude/skills/Brainstorming" = {
      source = "${claudeConfigSrc}/skills/Brainstorming";
      recursive = true;
    };
    "claude/skills/Createskill" = {
      source = "${claudeConfigSrc}/skills/Createskill";
      recursive = true;
    };
    "claude/skills/SystematicDebugging" = {
      source = "${claudeConfigSrc}/skills/SystematicDebugging";
      recursive = true;
    };
    "claude/skills/TestDrivenDevelopment" = {
      source = "${claudeConfigSrc}/skills/TestDrivenDevelopment";
      recursive = true;
    };
    "claude/skills/UsingGitWorktrees" = {
      source = "${claudeConfigSrc}/skills/UsingGitWorktrees";
      recursive = true;
    };
    "claude/skills/WritingPlans" = {
      source = "${claudeConfigSrc}/skills/WritingPlans";
      recursive = true;
    };
  };
}
