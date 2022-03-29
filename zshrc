# update path - hardcoded default path for ubuntu derivates, avoid tmux path spam
CUSTOM_PATH=$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin
DEFAULT_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PATH=$CUSTOM_PATH:$DEFAULT_PATH

# load starhip prompt
eval "$(starship init zsh)"

# set vault environment
export VAULT_ADDR=https://vault.local.fitztech.io:8200
alias vlog="vault login -method=oidc -path=AzureAD"
alias vcert="vault write -field=signed_key ssh-client-signer/sign/admin public_key=@$HOME/.ssh/id_ed25519.pub ttl=12h > $HOME/.ssh/id_ed25519-cert.pub"

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

# load custom zsh functions
fpath=( $HOME/.zsh_functions "${fpath[@]}" )
for filename in $HOME/.zsh_functions/*
do
  autoload -Uz $(basename ${filename})
done

# load ssh agent on shell start
GOT_AGENT=0

for FILE in $(find /tmp/ssh-* -type s -user ${LOGNAME} -name "agent.[0-9]*" 2>/dev/null)
do
  SOCK_PID=${FILE##*.}

  PID=$(ps -fu${LOGNAME}|awk '/ssh-agent/ && ( $2=='${SOCK_PID}' || $3=='${SOCK_PID}' || $2=='${SOCK_PID}' +1 ) {print $2}')

  SOCK_FILE=${FILE}

  SSH_AUTH_SOCK=${SOCK_FILE}; export SSH_AUTH_SOCK;
  SSH_AGENT_PID=${PID}; export SSH_AGENT_PID;

  ssh-add -l > /dev/null 2>&1
  if [ $? != 2 ]
  then
    GOT_AGENT=1
    break
  fi
done

if [ $GOT_AGENT = 0 ]
then
  eval `ssh-agent` > /dev/null
fi
