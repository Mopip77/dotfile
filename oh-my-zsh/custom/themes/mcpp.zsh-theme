## ---------------- Virtualenv -----------------------------
virtenv_prompt() {
	[[ -n ${VIRTUAL_ENV} ]] || return
	echo " ${YS_THEME_VIRTUALENV_PROMPT_PREFIX}(${VIRTUAL_ENV:t})${YS_THEME_VIRTUALENV_PROMPT_SUFFIX} "
}
local VENV_INFO="$(virtenv_prompt)"
YS_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[green]%}"
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=" %{$reset_color%}"

## ----------------- GIT INFO  -----------------------------
function git_info() {
	if [[ -z ${IS_GIT_REPO} ]]; then
		return
	fi

    GIT_CUSTOM_INFO=${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}  # escape %
	GIT_CUSTOM_INFO="<${GIT_CUSTOM_INFO}"
    (( VCS_STATUS_NUM_STAGED    )) && GIT_CUSTOM_INFO+="%{$fg[cyan]%}+%{$reset_color%}"
    (( VCS_STATUS_NUM_UNSTAGED  )) && GIT_CUSTOM_INFO+="%{$fg[yellow]%}!%{$reset_color%}"
    (( VCS_STATUS_NUM_UNTRACKED )) && GIT_CUSTOM_INFO+="%{$fg[red]%}?%{$reset_color%}"
	#echo "$GIT_CUSTOM_INFO%{$fg_bold[white]%}>%{$reset_color%} "
	echo "$GIT_CUSTOM_INFO> "
}

## ------------------ COMMAND TIME ------------------------
function last_cmd_exec_time() {
	if [ $COMMAND_ELAPSED_MS ]; then
		echo "%{$fg[cyan]%}${COMMAND_ELAPSED_MS}ms %{$reset_color%}"
	fi
}

function new_line() {
	local pwd="${PWD/$HOME/~}"
	if [ ${#pwd} -gt 30 ]; then
		echo "\n%{$fg_bold[yellow]%}> %{$reset_color%}"
	fi
}

## ------------------ DISPLAY FIELDS -----------------------
LAST_STATUS="%(?:🎾:😡) "
PATH_INFO="%{$fg[cyan]%}%~%{$reset_color%} "

## ------------------- PROMPTS -----------------------------
PROMPT='${LAST_STATUS}${VENV_INFO}${PATH_INFO}$(git_info)$(new_line)'
#RPS1='%{$reset_color%}$(last_cmd_exec_time)'
RPROMPT='$(last_cmd_exec_time)'
