#!/bin/zsh
### -------------------------- fzf-tab preview -------------------------

export FZF_TMUX_OPTS="-p 80%,60%" # 控制着fzf的window 是 popup 的还是 split panel 的

# 更稳健的 tmux 检测：确认“当前 TTY”确实属于某个 tmux pane
__fzf_tab_in_tmux_here() {
  command -v tmux >/dev/null 2>&1 || return 1
  local cur_tty pane_ttys
  cur_tty=$(tty 2>/dev/null) || return 1
  # 遍历所有 pane 的 TTY，与当前 TTY 比较
  pane_ttys=$(tmux list-panes -a -F '#{pane_tty}' 2>/dev/null) || return 1
  [[ -n "$pane_ttys" ]] || return 1
  print -- "$pane_ttys" | grep -qx -- "$cur_tty"
}

# 在“当前终端确实是 tmux pane”时使用 tmux popup，否则使用普通 fzf
if __fzf_tab_in_tmux_here; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
else
  zstyle ':fzf-tab:*' fzf-command fzf
  export FZF_TMUX=0
fi
zstyle ':fzf-tab:*' popup-pad 20 0
zstyle ':fzf-tab:*' fzf-pad 4

# environment variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
