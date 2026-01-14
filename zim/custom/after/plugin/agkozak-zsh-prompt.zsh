# 命令执行时间和格式
AGKOZAK_CMD_EXEC_TIME=3
AGKOZAK_CMD_EXEC_TIME_CHARS=( '~' '' )

# 最后展示的目录层级，超过的部分用...代替
AGKOZAK_PROMPT_DIRTRIM=4

# 命令执行状态和格式
AGKOZAK_COLORS_PATH='cyan'
AGKOZAK_MULTILINE=0
AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
AGKOZAK_COLORS_PROMPT_CHAR='#F68C58'
AGKOZAK_COLORS_USER_HOST='#BBDEFB'

# git 信息
AGKOZAK_LEFT_PROMPT_ONLY=1
AGKOZAK_COLORS_BRANCH_STATUS=243
AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' 'S')

# python 虚拟环境
AGKOZAK_COLORS_VIRTUALENV='#F2F89D'
AGKOZAK_VIRTUALENV_CHARS=( ' ' '' )


# proxy status
function agkozak_proxy_status() {
    if [[ -n "$http_proxy" || -n "$https_proxy" ]]; then
        # 在一些特殊场景下，比如在 IDEA 中，用普通的文本展示，避免兼容问题
        if [[ -n "$IN_IDEA" ]]; then
            printf '%s' "[P]"
        else
            printf '%s' "%F{227}%B⚡%b%f"  # 浅黄色 + 加粗
        fi
    fi
}

# env status
function get_env_status() {
    # .env is symbol link
    if [[ ! -L .env ]]; then
        return
    fi

    local enviroment
    enviroment=$(readlink .env | cut -d '.' -f 3)

    if [[ -n "$enviroment" ]]; then
        printf '%s' "($enviroment)"
    fi
}

# private mode
function is_private_mode() {
    if [[ -z "$HISTFILE" ]]; then
        printf '%s' "🫣"
    fi
}

# 右侧提示符
AGKOZAK_CUSTOM_RPROMPT+='$(get_env_status)'
AGKOZAK_CUSTOM_RPROMPT+='$(agkozak_proxy_status)'
AGKOZAK_CUSTOM_RPROMPT+='$(is_private_mode)'
