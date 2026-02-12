{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # AI Interface
    crush

    # editors
    inputs.llm-agents.packages.${pkgs.system}.claude-code
    code-cursor
    cursor-cli

    # MCP Servers
    github-mcp-server
  ];
}
