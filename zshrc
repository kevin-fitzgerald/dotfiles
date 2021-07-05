# update path - hardcoded default path for ubuntu derivates, avoid tmux path spam
CUSTOM_PATH=$HOME/.local/bin
DEFAULT_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PATH=$CUSTOM_PATH:$DEFAULT_PATH

# load starhip prompt
eval "$(starship init zsh)"

# attach to default tmux session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach -t base || exec tmux new -s base && exit;
fi

