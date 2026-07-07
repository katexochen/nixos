#!/usr/bin/env bash

allows=()
add_dirs=()

# Allow nix builds in the sandbox
allows+=(--allow ~/.cache/nix)

# Claude Code keeps its per-session scratchpad, bash-output
# capture and transcripts under /tmp/claude-$UID. nono
# only applies a filesystem grant whose target path already
# exists when the sandbox starts. Claude creates that temp dir
# lazily after the sandbox is up, and Claude can write but not
# read back its own bash output.
# Pre-create and explicitly grant the resolved dir.
export CLAUDE_CODE_TMPDIR=/tmp
tmproot="/tmp/claude-$(id -u)"
mkdir -p "$tmproot"
allows+=(--allow "$tmproot")

# For worktrees, also allow the common git dir so git works in sandbox.
grant_git_commondir() {
local common
    common=$(git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 0
    allows+=(--allow "$common")
}
grant_git_commondir .

for src in "$@"; do
    allows+=(--allow "$src")
    add_dirs+=(--add-dir "$src")
    grant_git_commondir "$src"
done

exec nono run \
    --allow-cwd \
    "${allows[@]}" \
    --profile claude-code \
    -- \
    claude --dangerously-skip-permissions "${add_dirs[@]}"
