{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # AI Interface
    crush

    # editors
    claude-code
    code-cursor
    cursor-cli

    # MCP Servers
    github-mcp-server
  ];
}
