# Suggested Replies — agent instructions

<!-- shared-rules:v1 -->
Shared rules, skills and helper roles load on their own from this machine's
global instructions (source: fleet-infra `agent_policy` and `skills`). This file
holds only what is special about this project. A shared safety or approval rule
wins over this file; for project facts, this file wins.
<!-- /shared-rules -->

## What this is

A public, dependency-free instruction block that makes a coding agent end each
reply with two or three numbered next steps. It works anywhere plain text shows
up (T3 Code, Claude Code, Codex). The files:

- `snippet.md`: the block itself, between its `suggested-replies:start` and
  `suggested-replies:end` markers (the start marker carries the version, now `v1`).
- `INSTALL.md`: step-by-step install instructions written for an agent.
- `install.sh`: adds, updates or removes the block in the Claude Code and Codex
  global instruction files.
- `README.md` and `images/`: the human-facing page and its example images.

## How to run and check it

There is no CI. Before a change lands:

1. `shellcheck install.sh` (the repository gate).
2. Run `install.sh` with `HOME` set to a temporary folder that contains `.claude`
   and `.codex`, and with `CLAUDE_CONFIG_DIR` and `CODEX_HOME` unset: install
   twice (the second run must report `updated`, and the block must appear exactly
   once in each file), then `--uninstall` (files the script created are removed).

## What must not break

- **Public and generic.** This is the public version of a private rule. Keep host
  names, private paths, personal details and private policy out of every file,
  including images.
- **Only the marked block is ever touched.** `install.sh` and `INSTALL.md` change
  nothing outside the markers, replace an existing block instead of adding a
  second one, write through a symlinked instruction file, skip agents whose
  config folder does not exist, and on uninstall delete a file only if the block
  was all it held.
- **No dependencies, plugins or servers.** `install.sh` stays plain Bash with
  standard tools.
- **One source for the rules.** The wording lives in `snippet.md`; the README's
  rules table and `INSTALL.md` describe the same rules, so keep them consistent.
- **Dark example images** in `images/`.

## How it ships

Merging to `main` publishes it: users install from the GitHub repository and the
raw `snippet.md` URL in `INSTALL.md`. There is no package or release step.

## Skills this project leans on

- Pull request ready: `git-pr-babysit`.
- New or changed README images: `visual-acceptance`.
- No project-local skills.

## Where to look

- `README.md`: what it does, the rules and why each exists.
- `INSTALL.md`: the agent-facing install and uninstall contract.
- `snippet.md`, `install.sh`.
