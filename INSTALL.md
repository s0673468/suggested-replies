# Install suggested replies: instructions for AI agents

You are an AI coding agent, and your user asked you to install this. It adds one
short instruction block to your global instructions. Afterwards, every reply ends
with two or three numbered next steps, and the user can answer with just a number.

## Steps

1. **Get the block.** It is everything in [`snippet.md`](snippet.md), including
   the two marker comments. Raw URL:
   `https://raw.githubusercontent.com/s0673468/suggested-replies/main/snippet.md`

2. **Find the global instruction files.** Only use agents whose config folder
   already exists on this machine:

   | Agent | File |
   | --- | --- |
   | Claude Code (also inside T3 Code) | `$CLAUDE_CONFIG_DIR/CLAUDE.md`, default `~/.claude/CLAUDE.md` |
   | Codex (also inside T3 Code) | `$CODEX_HOME/AGENTS.md`, default `~/.codex/AGENTS.md` |
   | Any other agent | Its global instruction file, if the user wants it (untested) |

   If the user asked for one project only, use that repository's `CLAUDE.md` or
   `AGENTS.md` instead.

3. **Add the block to each file.**
   - If the file already has `<!-- suggested-replies:start`, replace everything
     from that line through `<!-- suggested-replies:end -->` with the new block.
   - If the file already has a similar rule (search for "suggested replies",
     "follow-up" or "next steps"), tell the user instead of adding a second one.
   - If a tool generates the file (its header says so), add the block to that
     tool's source instead, so the next sync doesn't erase it.
   - Otherwise, add one blank line and then the block at the end. Create the file
     if it doesn't exist.
   - Never change anything outside the markers. If the file is a symlink, write
     through it.

   Shortcut: if you can run shell commands, `git clone` this repository and run
   `./install.sh`. It adds or replaces the block for Claude Code and Codex. It
   does not look for similar rules or generated files, so do those two checks first.

4. **Check.** Read each file back and confirm the block appears exactly once.

5. **Report.** Tell the user which files changed and that the rule takes effect
   in a new chat. End your reply with a `Suggested replies:` list, so they see it working.

## Uninstall

Delete the lines from `<!-- suggested-replies:start` through
`<!-- suggested-replies:end -->`, or run `./install.sh --uninstall` from the
cloned folder. The script deletes a file only if the block was all it held.
