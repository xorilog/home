package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"
)

// ToolUseData represents the input from PreToolUse hook
type ToolUseData struct {
	ToolName  string          `json:"tool_name"`
	ToolInput json.RawMessage `json:"tool_input"`
}

// BashInput represents Bash tool input
type BashInput struct {
	Command string `json:"command"`
}

func main() {
	// Read input from stdin
	input, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[validate-git-push] Error reading stdin: %v\n", err)
		os.Exit(0)
	}

	if len(input) == 0 {
		os.Exit(0)
	}

	var data ToolUseData
	if err := json.Unmarshal(input, &data); err != nil {
		fmt.Fprintf(os.Stderr, "[validate-git-push] Error parsing JSON: %v\n", err)
		os.Exit(0)
	}

	// Only check Bash commands
	if data.ToolName != "Bash" {
		os.Exit(0)
	}

	var bashInput BashInput
	if err := json.Unmarshal(data.ToolInput, &bashInput); err != nil {
		os.Exit(0)
	}

	cmd := strings.TrimSpace(bashInput.Command)

	// Check for dangerous push patterns
	if isForceMainPush(cmd) {
		// Output warning to stdout (Claude receives this)
		fmt.Println("⚠️ BLOCKED: Force push to main/master branch detected!")
		fmt.Println("This command would force-push to a protected branch.")
		fmt.Println("If you really need to do this, please confirm explicitly.")
		os.Exit(2) // Non-zero exit blocks the tool execution
	}

	os.Exit(0)
}

// isForceMainPush checks if the command is a force push to main/master
func isForceMainPush(cmd string) bool {
	// Must be a git push command
	if !strings.Contains(cmd, "git push") && !strings.Contains(cmd, "git push") {
		return false
	}

	// Check for force flags
	hasForce := strings.Contains(cmd, "--force") || strings.Contains(cmd, "-f")
	if !hasForce {
		return false
	}

	// Check for main/master branch
	hasProtectedBranch := strings.Contains(cmd, " main") || strings.Contains(cmd, " master")

	return hasProtectedBranch
}
