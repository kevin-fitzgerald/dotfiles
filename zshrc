# update path - hardcoded default path for ubuntu derivates, avoid tmux path spam
CUSTOM_PATH=$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin
DEFAULT_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PATH=$CUSTOM_PATH:$DEFAULT_PATH

# load starhip prompt
eval "$(starship init zsh)"

# attach to default tmux session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach -t base || exec tmux new -s base && exit;
fi

## wsl hack to get ssh-agent working
# /usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
# source $HOME/.keychain/$HOST-sh

# remap home and end keys for wsl2
bindkey '^?'       backward-delete-char              # bs         delete one char backward
bindkey '^[[3~'    delete-char                       # delete     delete one char forward
bindkey '^[[1~'    beginning-of-line                 # home       go to the beginning of line
bindkey '^[[4~'    end-of-line                       # end        go to the end of line
bindkey '^[[1;5C'  forward-word                      # ctrl+right go forward one word
bindkey '^[[1;5D'  backward-word                     # ctrl+left  go backward one word
bindkey '^H'       backward-kill-word                # ctrl+bs    delete previous word
bindkey '^[[3;5~'  kill-word                         # ctrl+del   delete next word
bindkey '^J'       backward-kill-line                # ctrl+j     delete everything before cursor
bindkey '^[[D~'    backward-char                     # left       move cursor one char backward
bindkey '^[[C~'    forward-char                      # right      move cursor one char forward
bindkey '^[[A~'    up-line-or-beginning-search       # up         prev command in history
bindkey '^[[B~'    down-line-or-beginning-search     # down       next command in history
bindkey '^[[5~'    history-beginning-search-backward #pgup        prev command in history
bindkey '^[[6~'    history-beginning-search-forward  #pgdown      next command in history
# GoLang
export GOROOT=/home/kevin/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/kevin/go
export PATH=$GOPATH/bin:$PATH
