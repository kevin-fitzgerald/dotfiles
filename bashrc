# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Load ssh-agent
GOT_AGENT=0

## Load existing agent if found
for FILE in $(find /tmp -maxdepth 1 -name "ssh-*" -type d -exec find {} -type s -user ${LOGNAME} -name "agent.[0-9]*" \; 2>/dev/null)
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

## Create new agent if none is found
if [ $GOT_AGENT = 0 ]
then
    eval `ssh-agent` > /dev/null

    ### Optionally load all keys on creation
    find ~/.ssh -type f ! -name "*.pub" ! -name "known_hosts" ! -name "config" ! -name "authorized_keys" -exec ssh-add {} \; &>/dev/null
fi

# Set custom environment variables
export EDITOR="/usr/bin/vim"

# Load starship prompt
eval "$(starship init bash)"
