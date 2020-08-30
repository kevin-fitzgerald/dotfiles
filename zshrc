# Path to your oh-my-zsh installation.
# See oh-my-zsh installation details at https://github.com/ohmyzsh/ohmyzsh
export ZSH="$HOME/.oh-my-zsh"

# ZSH theme
# See spaceship theme installation details at https://github.com/denysdovhan/spaceship-prompt
ZSH_THEME="spaceship"

# Plugins loaded on startup
plugins=(
    git # Adds aliases for common git commands
    tmux # Adds aliases for common tmux commands
)

# Start up oh-my-zsh env
source $ZSH/oh-my-zsh.sh

# Add go lang binary to path
export PATH=$PATH:/usr/local/go/bin

# Add user Go package binary folder to path
export PATH=$PATH:$HOME/go/bin

# Add pip installation directory to path
export PATH=$PATH:$HOME/.local/bin

# Add cargo binaries to path
export PATH=$PATH:$HOME/.cargo/bin

# Start tmux session on launch
if [ "$TMUX" = "" ]; then tmux; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

complete -o nospace -C /usr/local/bin/vault vault

# Set vault address
export VAULT_ADDR="https://vault.fitztech.io:8200"

