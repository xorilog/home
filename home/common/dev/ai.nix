{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # AI Interface
    crush

    # editors
    inputs.llm-agents.packages.${pkgs.system}.claude-code
    inputs.llm-agents.packages.${pkgs.system}.herdr

    # MCP Servers
    github-mcp-server
  ];
}
