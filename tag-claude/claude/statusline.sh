  #!/bin/bash

  # Claude Code StatusLine Script
  # Includes: directory trimming, git status, virtualenv, and custom indicators

  # Read JSON input from stdin
  input=$(cat)

  # Extract current directory from JSON
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

  # Function to trim directory path (mimicking AGKOZAK_PROMPT_DIRTRIM=4)
  trim_directory() {
      local dir="$1"
      local max_components=4

      # Replace home directory with ~
      dir=${dir/#$HOME/\~}

      # Split path into components
      IFS='/' read -ra components <<< "$dir"
      local component_count=${#components[@]}

      if [ $component_count -gt $max_components ]; then
          # Show first component (~ or root) and last 3 components
          if [[ "${components[0]}" == "~" ]]; then
              echo "~/.../${components[-3]}/${components[-2]}/${components[-1]}"
          else
              echo "/.../${components[-3]}/${components[-2]}/${components[-1]}"
          fi
      else
          echo "$dir"
      fi
  }

  # Function to get git branch and status
  get_git_status() {
      if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
          local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
          local status=""
          local color="\033[32m"  # Green for clean

          # Check for various git states
          if ! git diff --quiet 2>/dev/null; then
              status+="*"  # Modified files
              color="\033[33m"  # Yellow
          fi

          if ! git diff --cached --quiet 2>/dev/null; then
              status+="+"  # Staged files
              color="\033[33m"  # Yellow
          fi

          if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
              status+="?"  # Untracked files
              color="\033[31m"  # Red
          fi

          local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
          local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)

          if [ "$ahead" -gt 0 ] 2>/dev/null; then
              status+="↑$ahead"
          fi

          if [ "$behind" -gt 0 ] 2>/dev/null; then
              status+="↓$behind"
          fi

          if [ -n "$status" ]; then
              printf "${color}(%s %s)\033[0m" "$branch" "$status"
          else
              printf "\033[32m(%s)\033[0m" "$branch"
          fi
      fi
  }

  # Function to get virtual environment
  get_virtualenv() {
      if [ -n "$VIRTUAL_ENV" ]; then
          local venv_name=$(basename "$VIRTUAL_ENV")
          printf "\033[36m(%s)\033[0m" "$venv_name"
      elif [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
          printf "\033[36m(%s)\033[0m" "$CONDA_DEFAULT_ENV"
      fi
  }

  # Function to get custom status indicators
  get_custom_indicators() {
      local indicators=""

      # Check for proxy settings
      if [ -n "$HTTP_PROXY" ] || [ -n "$HTTPS_PROXY" ] || [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
          indicators+=" \033[35m[PROXY]\033[0m"
      fi

      # Check for development environment
      if [ -n "$NODE_ENV" ] && [ "$NODE_ENV" != "production" ]; then
          indicators+=" \033[33m[DEV]\033[0m"
      fi

      # Check for private/incognito mode indicators
      if [ -n "$PRIVATE_MODE" ] || [ -n "$INCOGNITO" ]; then
          indicators+=" \033[31m[PRIVATE]\033[0m"
      fi

      # Check for SSH connection
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          indicators+=" \033[34m[SSH]\033[0m"
      fi

      echo "$indicators"
  }

  # Change to the current directory for git operations
  cd "$current_dir" 2>/dev/null || true

  # Build the status line
  trimmed_dir=$(trim_directory "$current_dir")
  git_status=$(get_git_status)
  venv_info=$(get_virtualenv)
  custom_indicators=$(get_custom_indicators)

  # Construct the final status line
  status_line=""

  # Add virtual environment if present
  if [ -n "$venv_info" ]; then
      status_line+="$venv_info "
  fi

  # Add directory
  status_line+="\033[34m$trimmed_dir\033[0m"

  # Add git status if in a git repository
  if [ -n "$git_status" ]; then
      status_line+=" $git_status"
  fi

  # Add custom indicators
  if [ -n "$custom_indicators" ]; then
      status_line+="$custom_indicators"
  fi

  # Output the final status line
  printf "$status_line"

