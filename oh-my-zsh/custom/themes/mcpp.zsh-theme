## ---------------- Virtualenv -----------------------------
virtenv_prompt() {
	[[ -n ${VIRTUAL_ENV} ]] || return
	echo " %{$fg_bold[green]%}(${VIRTUAL_ENV:t})%{$reset_color%} "
}

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
	echo "${GIT_CUSTOM_INFO}> "
}

## ------------------ COMMAND TIME ------------------------
function last_cmd_exec_time() {
	if [ $COMMAND_ELAPSED_MS ]; then
		local hours=$(( $COMMAND_ELAPSED_MS / 1000 / 60 / 60 ))
		[[ $hours -eq 0 ]] && hours="" || hours="${hours}:"
		local minutes=$(( $COMMAND_ELAPSED_MS / 1000 / 60 % 60 ))
		[[ -z $hours && $minutes -eq 0 ]] && minutes="" || minutes="${minutes}:"
		local seconds=$(( $COMMAND_ELAPSED_MS / 1000 % 60 ))
		[[ -z $minutes && $seconds -eq 0 ]] && seconds="" || seconds="${seconds}"
		local ms=$(( $COMMAND_ELAPSED_MS % 1000 ))
		[[ -z $seconds && $ms -eq 0 ]] && ms="" || ms=$(printf ".%03d" $ms)
		#echo "%{$fg[cyan]%}${hours}${minutes}${seconds}${ms} %{$reset_color%}"
		echo "%F{#FCB667}${hours}${minutes}${seconds}${ms} %{$reset_color%}"
	fi
}

function new_line() {
	local pwd="${PWD/$HOME/~}"
	if [ ${#pwd} -gt 30 ]; then
		echo "\n%{$fg_bold[yellow]%}> %{$reset_color%}"
	fi
}

## ------------------ PROXY STATUS -----------------------
function proxy_status() {
	if [ -n "${http_proxy:=}" ]; then
		echo "✈️  "
	fi
}

## ------------------ DISPLAY FIELDS -----------------------
PATH_COLOR="%(?.%B%F{cyan}.%B%F{red})"
PATH_INFO="%~%{$reset_color%} "

## ------------------- PROMPTS -----------------------------
PROMPT='$(proxy_status)$(virtenv_prompt)${PATH_COLOR}${PATH_INFO}$(git_info)$(new_line)'
RPROMPT='$(last_cmd_exec_time)'
