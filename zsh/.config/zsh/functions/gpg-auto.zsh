function gpg-auto(){
  if [ -f $HOME/.gpg-agent-info ]; then
    . $HOME/.gpg-agent-info
    export GPG_AGENT_INFO
  fi

  if [ ! -f $HOME/.gpg-agent.conf ]; then
    echo "default-cache-ttl 604800" >> $HOME/.gpg-agent.conf
    echo "max-cache-ttl 604800" >> $HOME/.gpg-agent.conf
    echo "default-cache-ttl-ssh 604800" >> $HOME/.gpg-agent.conf
    echo "max-cache-ttl-ssh 604800" >> $HOME/.gpg-agent.conf
  fi

  if [ -n "${GPG_AGENT_INFO}" ]; then
    nc  -U "${GPG_AGENT_INFO%%:*}" >/dev/null </dev/null
    if [ ! -S "${GPG_AGENT_INFO%%:*}" -o $? != 0 ]; then
      # set passphrase cache so I only have to type my passphrase once a day
      eval $(gpg-agent --options $HOME/.gpg-agent.conf --daemon --write-env-file $HOME/.gpg-agent-info --use-standard-socket --log-file $HOME/tmp/gpg-agent.log --verbose)
    fi
  fi
  export GPG_TTY=$(tty)
}

gpg-auto
