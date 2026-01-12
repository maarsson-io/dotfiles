#!/usr/bin/env sh
set -eu

REPO_URL="${REPO_URL:-https://github.com/maarsson/dotfiles.git}"
GIT_DIR="$HOME/.dotfiles"
CFG_DIR="${HOME}/.config/dotfiles"
IGNORE_FILE="${CFG_DIR}/ignore"
LOCAL_GITCONFIG="$HOME/.gitconfig.local"

info() { printf "[\033[34mINFO\033[0m] %s\n" "$1"; }
ok() { printf "[\033[32m OK \033[0m] %s\n" "$1"; }
fail() { printf "[\033[31mFAIL\033[0m] %s\n" "$1" >&2; exit 1; }
dotfiles() { git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"; }

command -v git >/dev/null 2>&1 || fail "git is required"

if [ -e "$GIT_DIR" ]; then
    fail "${GIT_DIR} already exists. Aborting."
fi

mkdir -p "$CFG_DIR"

if [ ! -f "$IGNORE_FILE" ]; then
    info "Creating ignore file..."
    cat > "$IGNORE_FILE" <<'EOF'
# dotfiles repo ignores (repo-local via core.excludesFile)
# Keep this focused on secrets, history, and OS/app state.

# Shell history
.bash_history
.zsh_history
.histfile

# SSH secrets and noisy state
.ssh/id_*
.ssh/*_rsa
.ssh/*_ed25519
.ssh/known_hosts
.ssh/authorized_keys

# Common OS/app state
.DS_Store
.Trashes
.Spotlight-V100
.fseventsd

.cache/
.local/share/
.local/state/
EOF
else
    info "Ignore file already exists, leaving it as-is."
fi

info "Cloning dotfiles repository to ${GIT_DIR}..."
git clone --bare "$REPO_URL" "$GIT_DIR"

info "Configuring local settings..."
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local core.excludesFile "$IGNORE_FILE"

info "Checking out tracked files..."
if ! dotfiles checkout; then
    fail "Checkout failed (existing files would be overwritten). Move conflicting files away and re-run, or run: dotfiles checkout"
fi

dotfiles submodule update --init --recursive 2>/dev/null || true

if [ ! -f "$LOCAL_GITCONFIG" ]; then
    info "Creating user configuration file..."

    # Optional interactive prompt if running in a TTY
    if [ -t 0 ]; then
        printf "Git name: "
        IFS= read -r GIT_NAME || true
        printf "Git email: "
        IFS= read -r GIT_EMAIL || true
    fi

    GIT_NAME="${GIT_NAME:-Your Name}"
    GIT_EMAIL="${GIT_EMAIL:-you@example.com}"

    cat > "$LOCAL_GITCONFIG" <<EOF
[user]
    name = ${GIT_NAME}
    email = ${GIT_EMAIL}
EOF
else
    info "$HOME/.gitconfig.local already exists, leaving it as-is."
fi

ok "Setting up dotfiles repository done."
