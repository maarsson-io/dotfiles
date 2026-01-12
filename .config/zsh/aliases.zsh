# Only load in interactive shells
[[ -o interactive ]] || return

# Dotfiles git command
alias dotfiles='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

# Reload the shell
alias reload='exec "$SHELL" -l'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Folder shortcuts
alias dl='cd "$HOME/Downloads"'
alias dt='cd "$HOME/Desktop"'
alias c='cd "$HOME/Code"'
alias h='cd "$HOME/Herd"'
alias s='cd "$HOME/Sync"'

# File shortcuts
alias aliases='subl "$HOME/.config/zsh/aliases.zsh"'
alias hist='subl ~/.zsh_history'
alias zs='subl ~/.zshrc'

# Listings
alias la='ls -a' # include hidden files
alias ll='ls -lh' # detailed listing
alias lla='ls -lah' # include hidden files
alias lll='ls -ltr' # sorted by updated date
alias df='df -h' # human readable df

# Print PATH entries
path() { printf '%s\n' "${PATH//:/$'\n'}"; }

# IP addresses
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'

# macOS-only
if [[ "$OSTYPE" == darwin* ]]; then
  alias localip='ipconfig getifaddr en0'
  alias showhidden='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
  alias hidehidden='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
  alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'
  alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'

  # Get macOS Software Updates, and update Homebrew, npm, and their installed packages
  alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; '
  # Generate random password
  command -v pbcopy >/dev/null 2>&1 && \
    alias genpass="LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16 | pbcopy && echo 'Random password copied to clipboard'"
fi

# Apps (macOS paths; guard)
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -x "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]] && \
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
  [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]] && \
    alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
fi

# PHP / Laravel (Herd is macOS-only; guard)
if command -v herd >/dev/null 2>&1; then
  alias composer='herd composer'
  alias php='herd php'
  alias a='herd php artisan'
  alias fresh='herd php artisan migrate:fresh --seed'
  alias seed='herd php artisan db:seed'
  alias serve='herd php artisan serve'
  queue() {
    herd php artisan queue:clear --queue="${1:?queue name required}" \
      && herd php artisan queue:listen --queue="$1"
  }
fi

# Misc
alias week='date +%V'

command -v timew >/dev/null 2>&1 && {
  alias tww='timew week'
  alias twr='timew tagreport from'
}

command -v desk >/dev/null 2>&1 && alias d.='desk go'
command -v htop >/dev/null 2>&1 && alias htop='sudo htop'
command -v fuck >/dev/null 2>&1 && alias f='fuck'
