{
  buildGoModule,
  lib,
}:

buildGoModule {
  pname = "claude-hooks";
  version = "0.1.0";
  src = ./.;

  vendorHash = null;

  # Build all binaries
  subPackages = [
    "cmd/capture-tool-output"
    "cmd/initialize-session"
    "cmd/update-terminal-title"
    "cmd/save-session"
    "cmd/session-stats"
    "cmd/validate-git-push"
  ];

  # Rename binaries to have consistent prefix
  postInstall = ''
    mv $out/bin/capture-tool-output $out/bin/claude-hooks-capture-tool-output
    mv $out/bin/initialize-session $out/bin/claude-hooks-initialize-session
    mv $out/bin/update-terminal-title $out/bin/claude-hooks-update-terminal-title
    mv $out/bin/save-session $out/bin/claude-hooks-save-session
    mv $out/bin/session-stats $out/bin/claude-hooks-session-stats
    mv $out/bin/validate-git-push $out/bin/claude-hooks-validate-git-push
  '';

  meta = {
    description = "Claude Code hooks for session management, tool output capture, and git safety";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "claude-hooks-initialize-session";
  };
}
