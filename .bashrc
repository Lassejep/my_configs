# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME=$HOME/.config
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# set locale
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export PATH=$PATH:~/lobster/bin
export PATH=$PATH:/usr/local/texlive/2023/bin/x86_64-linux
export EDITOR=nvim
export MANPAGER='nvim +Man!'
source ~/.bash_aliases
source ~/.bash_scripts
PS1='\[\e[0;32m\]\u@\h \w\$: \[\e[m\]'
complete -cf sudo

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(zoxide init --cmd cd bash)"

# Created by `pipx` on 2024-03-07 06:33:50
export PATH="$PATH:/home/tinspring/.local/bin"
