# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

zmodload zsh/zprof

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#


# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
export EDITOR=nvim

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Color Settings
export CLICOLOR=1
export LSCOLORS=GxFxCxDxHxagadabagacad
export GREP_COLORS='sl=97;48;5;236:cx=37;40:mt=30;48;5;186:fn=38;5;197:ln=38;5;154:bn=38;5;141:se=38;5;81';
export GREP_OPTIONS="--color=never"
export GREP_COLOR='1;35;40'

# -----------------
# Zim configuration
# -----------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
ZIM_CUSTOM=${ZDOTDIR:-${HOME}}/.zim/custom

# Use degit instead of git as the default tool to install and update modules.
zstyle ':zim:zmodule' use 'git'

# --------------------
# Module configuration
# --------------------

# load custom configuration sets
if [ -d "${ZIM_CUSTOM}/after/plugin/" ]; then
    for file in `ls ${ZIM_CUSTOM}/after/plugin/*.zsh`; do
        source "$file"
    done
fi

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

# ------------------
# Initialize modules
# ------------------

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# completion
#
zstyle ':completion::complete:*' cache-path ${HOME}/.cache/zsh/completions

# ------------------------------
# custom configuration
# ------------------------------


### ------------------------ execution time --------------------------------

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

alias rgg="${ZIM_CUSTOM}/scripts/riggrep-fzf-vim.sh"
alias v="fasd -a -e $EDITOR"

### -------------------------- Third part source -----------------------------------

# custom scripts
source ${HOME}/.myScript
source ~/.zsh_enhance

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
FZF_DEFAULT_OPTS='--height 40% --layout=reverse --inline-info'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# lessfilter
export LESSOPEN='|~/.lessfilter %s'

# fasd
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
  # inject fzf completion
  gsed -i "s/\$compl\"/\$compl\" | fzf --height 40% --reverse --preview 'less {}'/" $fasd_cache
  # remove some alias
  gsed -i -E '/alias (a|s|sd|sf|zz)/d' $fasd_cache
fi
source "$fasd_cache"
unset fasd_cache
# fasd match text ignore case
export _FASD_NOCASE=1

# zsh completion auto generator
GENCOMPL_PY="/usr/bin/python3"
GENCOMPL_FPATH=${HOME}/.cache/zsh/completions
# too slow to initialize, and nearly not using. invoke manually.
#source ${ZIM_CUSTOM}/plugins/zsh-completion-generator/zsh-completion-generator.plugin.zsh
 #use `man2comp <command>` generate autosuggestions manually
#zstyle :plugin:zsh-completion-generator programs curl http locusts

# fzf-tab
source ${ZIM_CUSTOM}/scripts/fzf-tab-config.zsh

# fzf-browser
source ${ZIM_CUSTOM}/scripts/fzf-google-chrome.zsh

# direnv
_evalcache direnv hook $SHELL

# atuin
export ATUIN_NOBIND="true"
_evalcache atuin init zsh
# bind C-r to atuin
bindkey '^r' _atuin_search_widget

### ----------------------- Configuration ----------------------------------------

# php configuration
export LDFLAGS="-L/usr/local/opt/libffi/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# tidb tiup
export PATH=/Users/bjhl/.tiup/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
function __init_conda() {
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
# <<< conda initialize <<<
lazyload conda -- __init_conda

# }}} End configuration added by Zim install

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
