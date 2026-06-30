#!/usr/bin/env bash
# =============================================================================
# superset-setup.sh
# Superset worktree 初始化脚本
# 用于在新建 worktree 时执行初始化操作
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# 日志工具
# -----------------------------------------------------------------------------
log_info()  { echo "[INFO]  $*"; }
log_warn()  { echo "[WARN]  $*"; }
log_error() { echo "[ERROR] $*" >&2; }

# -----------------------------------------------------------------------------
# 模块: 初始化共享 knowledge 文件夹并软连接到当前目录
#
# 流程:
#   1. 从 SUPERSET_ROOT_PATH 解析出项目名称
#   2. 确保 ~/.config/claude-knowledge/<project_name> 目录存在
#   3. 将该目录软连接到当前目录的 .personal
# -----------------------------------------------------------------------------
setup_shared_knowledge() {
    # --- Step 1: 解析项目名称 ---
    if [[ -z "${SUPERSET_ROOT_PATH:-}" ]]; then
        log_error "环境变量 SUPERSET_ROOT_PATH 未设置，跳过共享 knowledge 初始化"
        return 1
    fi

    # 取绝对路径最后一级目录名作为 project_name
    local project_name
    project_name="$(basename "$SUPERSET_ROOT_PATH")"
    log_info "项目名称: ${project_name} (来源: SUPERSET_ROOT_PATH=${SUPERSET_ROOT_PATH})"

    # --- Step 2: 确保共享 knowledge 目录存在 ---
    local knowledge_base="${HOME}/.config/claude-knowledge"
    local knowledge_dir="${knowledge_base}/${project_name}"

    if [[ -d "$knowledge_dir" ]]; then
        log_info "共享 knowledge 目录已存在: ${knowledge_dir}"
    else
        log_info "创建共享 knowledge 目录: ${knowledge_dir}"
        mkdir -p "$knowledge_dir"
    fi

    # --- Step 3: 软连接到当前目录的 .personal ---
    local link_target="${PWD}/.personal"

    if [[ -L "$link_target" ]]; then
        local existing_target
        existing_target="$(readlink "$link_target")"
        if [[ "$existing_target" == "$knowledge_dir" ]]; then
            log_info "软连接已存在且指向正确: ${link_target} -> ${knowledge_dir}"
            return 0
        else
            log_warn "软连接已存在但指向不同目标: ${existing_target}，将更新为: ${knowledge_dir}"
            rm "$link_target"
        fi
    elif [[ -e "$link_target" ]]; then
        log_error ".personal 已存在且不是软连接，跳过以避免数据丢失"
        return 1
    fi

    ln -s "$knowledge_dir" "$link_target"
    log_info "已创建软连接: ${link_target} -> ${knowledge_dir}"
}

# -----------------------------------------------------------------------------
# 主入口
# -----------------------------------------------------------------------------
main() {
    log_info "========== Superset Worktree 初始化开始 =========="

    setup_shared_knowledge

    log_info "========== Superset Worktree 初始化完成 =========="
}

main "$@"
