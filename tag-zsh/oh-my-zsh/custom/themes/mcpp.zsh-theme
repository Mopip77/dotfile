## ---------------- Virtualenv -----------------------------
virtenv_prompt() {
	[[ -n ${VIRTUAL_ENV} ]] || return
	echo " ${YS_THEME_VIRTUALENV_PROMPT_PREFIX}(${VIRTUAL_ENV:t})${YS_THEME_VIRTUALENV_PROMPT_SUFFIX} "
}
local VENV_INFO="$(virtenv_prompt)"
YS_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[green]%}"
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=" %{$reset_color%}"

## ----------------- GIT INFO  -----------------------------
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}M%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}U%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_info() {
	local git_showing_msg="$(git_prompt_info)$(git_prompt_status)"
	[[ ! -z $git_showing_msg ]] && git_showing_msg="<${git_showing_msg}> "
	echo $git_showing_msg
}

## ------------------ DISPLAY FIELDS -----------------------
LAST_STATUS="%(?:🎾:😡) "
PATH_INFO="%{$fg[cyan]%}%~%{$reset_color%} "

PROMPT='${LAST_STATUS}${VENV_INFOj}${PATH_INFO}$(git_info)'
