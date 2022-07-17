# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mcpp"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-open extract branch vi-mode zsh-256color virtualenv)

source $ZSH/oh-my-zsh.sh

# antigen
source ${ZSH_CUSTOM}/deps/antigen.zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle command-not-found

antigen bundle Aloxaf/fzf-tab

# Tell Antigen that you're done.
antigen apply

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### ------------------------ oh-my-zsh execution time --------------------------------
function preexec() {
	timer=$(($(gdate +%s%0N)/1000000))
}

function precmd() {
	if [ $timer ]; then
		now=$(($(gdate +%s%0N)/1000000))
		export COMMAND_ELAPSED_MS=$(($now-$timer))
		unset timer
	else
		unset COMMAND_ELAPSED_MS
	fi
}

### -------------------------- Git Info -------------------------------------------
source ${ZSH_CUSTOM}/plugins/gitstatus/gitstatus.plugin.zsh

function my_set_prompt() {
	if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
		IS_GIT_REPO="1"
	else
		unset IS_GIT_REPO
	fi
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd my_set_prompt

### -------------------------- Alias ----------------------------------------------

alias rgg="${ZSH_CUSTOM}/scripts/riggrep-fzf-vim.sh"

### -------------------------- Third part source -----------------------------------

source ${ZSH_CUSTOM}/plugins/zsh-defer/zsh-defer.plugin.zsh

# custom scripts
zsh-defer source ${HOME}/.myScript
zsh-defer source ~/.zsh_enhance

# zsh plugins
zsh-defer source ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
zsh-defer source ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# direnv
_eval_direnv() { eval "$(direnv hook zsh)" }
zsh-defer _eval_direnv

# fzf
[ -f ~/.fzf.zsh ] && zsh-defer source ~/.fzf.zsh

# the fuck
_eval_thefuck() { eval $(thefuck --alias) }
zsh-defer _eval_thefuck

# fasd
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
  # injet fzf completion
  gsed -i "s/\$compl\"/\$compl\" | fzf --height 40% --reverse --preview 'less {}'/" $fasd_cache
fi
source "$fasd_cache"
unset fasd_cache

# pinyin completion 
source ${ZSH_CUSTOM}/plugins/pinyin-complete/pinyin-comp.zsh

# zsh completion auto generator
GENCOMPL_PY="/usr/bin/python3"
GENCOMPL_FPATH=${ZSH}/cache/completions
source ${ZSH_CUSTOM}/plugins/zsh-completion-generator/zsh-completion-generator.plugin.zsh
zstyle :plugin:zsh-completion-generator programs curl http

# fzf-tab
source ${ZSH_CUSTOM}/scripts/fzf-tab-config.zsh

# fzf-browser
source ${ZSH_CUSTOM}/scripts/fzf-google-chrome.zsh

### ----------------------- Configuration ----------------------------------------


# fasd-fzf
#source ${ZSH_CUSTOM}/scripts/fzf-fasd.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
function init_conda() {
	local __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
			. "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
		else
			export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
		fi
	fi
}
zsh-defer init_conda
# <<< conda initialize <<<
