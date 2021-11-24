# Virtualenv
local venv_info='$(virtenv_prompt)'
YS_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[green]%}"
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=" %{$reset_color%}"
virtenv_prompt() {
	[[ -n ${VIRTUAL_ENV} ]] || return
	echo "${YS_THEME_VIRTUALENV_PROMPT_PREFIX}(${VIRTUAL_ENV:t})${YS_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

PROMPT="%(?:🎾:😡) ${venv_info}"
PROMPT+='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{#ff87c8} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✘"
