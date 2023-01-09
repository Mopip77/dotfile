# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#A39587,bold,underline"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# 右箭头设置为每次接受一个字符
bindkey '^[[C' forward-char
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char})
# End设置为接受整行
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(end-of-line)

