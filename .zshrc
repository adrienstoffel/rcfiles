# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="awe"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.oh-my-zsh/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux colorize python zsh-syntax-highlighting dircycle)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"


# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

source $ZSH/oh-my-zsh.sh

# ls: colors and no accent issues
alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'

# Ask before deletion of a file
alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive'

# ls shortcuts
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Some usual shortcuts
alias c='clear'
alias less='less --quiet'
alias s='cd ..'
alias df='df --human-readable'
alias du='du --human-readable'
alias m='mutt -y'
alias md='mkdir'
alias rd='rmdir'
alias top='htop'
alias grep='grep --color'
alias psc='ps xawf -eo pid,user,cgroup,args'
alias py='ipython'
alias bpy='bpython'
alias py3='ipython3'
alias bpy3='bpython3'

# Special vars

export EDITOR=vim

# awesome specific

export XDG_CONFIG_HOME=$HOME/.config/

# utilities

alias checksec='pwn checksec'

alias peda='gdb -q -nx -x /usr/share/peda/peda.py'
alias gdb='gdb -q'
alias gef='gdb -q -nx -x /usr/share/gef/gef.py'
alias hcat='pygmentize -f terminal256'
alias tmux='TERM=screen-256color-bce tmux'

# laptop specific

alias irc='ssh -D9999 -i ~/.ssh/id_rsa_irc -R 4321:localhost:4321 awe@w3challs.com -t ". /etc/profile; . ~/.profile; . ~/.zshrc; TERM=screen-256color-bce tmux attach"'
alias update='yay -Syu --combinedupgrade'

export PAGER=most

export BROWSER="chromium"
