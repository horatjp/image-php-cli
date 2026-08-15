export EDITOR=vim           # Editor

setopt no_beep              # Disable beep sound
setopt correct              # Automatically correct command spelling
setopt auto_cd              # cd by typing directory name only
setopt interactive_comments # Allow comments on the command line


### Aliases
# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern tool replacements
alias ls='eza --icons'                             # Icon list
alias ll='eza --icons -l'                          # Detailed list
alias la='eza --icons -la'                         # Detailed list with hidden files
alias lt='eza --icons -l --sort=modified'          # Sort by modified time
alias tree='eza --tree --icons --git-ignore -L 4'  # Tree view
alias cat='bat'                                    # cat with syntax highlighting
alias top='btop'                                   # Graphical process monitor

# Utilities
alias relogin='exec $SHELL -l'             # Restart shell
alias myip='curl https://ipinfo.io/json'   # Show global IP
alias ports='lsof -i -P -n | grep LISTEN'  # Show listening ports


### History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"  # History file location
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000                   # Number of history entries kept in memory
SAVEHIST=100000                  # Number of history entries saved to file
setopt EXTENDED_HISTORY          # Record timestamp and duration
setopt INC_APPEND_HISTORY        # Append to history immediately after execution
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate commands
setopt HIST_IGNORE_SPACE         # Ignore commands starting with a space
setopt HIST_VERIFY               # Confirm before executing history expansion
setopt HIST_NO_STORE             # Do not record the history command itself
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks


### Zsh Plugins (znap)
[[ -r ~/.znap/zsh-snap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.znap/zsh-snap
source ~/.znap/zsh-snap/znap.zsh

# Real-time completion
znap source marlonrichert/zsh-autocomplete
zstyle ':autocomplete:*' min-delay 0.3            # Add delay for performance
zstyle ':autocomplete:*' min-input 2              # Start completion after 2 characters
zstyle ':autocomplete:*' max-lines 10             # Limit number of completion candidates
zstyle ':autocomplete:*' insert-unambiguous true  # Auto-insert unambiguous prefix

# History-based command suggestions
znap source zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'          # Suggestion color (gray)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)     # Suggest from history and completion

# Command syntax highlighting
znap source zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Keybindings
bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion


### Tools
# starship
eval "$(starship init zsh)"

# fzf
export FZF_DEFAULT_OPTS="--reverse --border --no-sort --prompt=' '"
(( $+commands[fzf] )) && eval "$(fzf --zsh)"

# gh completion
(( $+commands[gh] )) && eval "$(gh completion -s zsh)"

# mise
eval "$(mise activate zsh)"
eval "$(mise completion zsh)"
