
# maarsson/dotfiles

Public dotfiles managed as a Git bare repository.

- **Git directory:** `~/.dotfiles` (bare repo)
- **Work tree:** `~`
- **Command alias:** `dotfiles`

This repository intentionally tracks only selected files from `$HOME`. Machine-specific and sensitive data **must never be committed** and are intentionally excluded.

## Important security notes

- Never commit secrets (tokens, private keys, credential stores).
- Do not track `~/.ssh` private keys, `known_hosts`, shell history, or tool auth files.

## Install on new machine

Run the install script, that will also prompt for your git user details:

`curl -fsSL https://raw.githubusercontent.com/maarsson/dotfiles/master/.scripts/dotfiles-install.sh | /bin/sh`

## What is tracked

Typical tracked files (initial scope):
- `~/.gitconfig`
- `~/.gitignore_global`
- `~/.gitmessage`
- `.scripts/dotfiles-install.sh`

Not tracked:
- `~/.gitconfig.local` (sensitive data)
- `~/.config/dotfiles/ignore` (machine policy)

## Common commands

`dotfiles status`
`dotfiles add ~/.gitconfig`
`dotfiles commit -m "Update git config"`
`dotfiles push`

## Ignore policy

This setup uses a repo-local ignore file via:

`core.excludesFile = ~/.config/dotfiles/ignore`

Keep it focused on:
- secrets and credential paths
- history files
- OS/app state and caches
