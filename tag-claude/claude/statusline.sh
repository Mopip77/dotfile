  #!/bin/bash

  # Claude Code StatusLine Script
  # Includes: directory trimming, git status, virtualenv, and custom indicators

  # Configuration
  SHOW_PROGRESS_BAR=false  # Set to true to show progress bar, false to show only percentage

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
          printf "\033[1;33m(%s)\033[0m" "$venv_name"
      elif [ -n "$CONDA_DEFAULT_ENV" ]; then
          printf "\033[1;33m(%s)\033[0m" "$CONDA_DEFAULT_ENV"
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

  # Function to create a progress bar
  create_progress_bar() {
      local used=$1
      local limit=$2
      local width=10  # Progress bar width in characters

      if [ -z "$used" ] || [ -z "$limit" ] || [ "$limit" -eq 0 ]; then
          echo ""
          return
      fi

      local percentage=$((used * 100 / limit))
      local filled=$((width * used / limit))
      [ $filled -gt $width ] && filled=$width

      local empty=$((width - filled))

      # Choose color based on percentage
      local color="\033[32m"  # Green
      if [ $percentage -ge 90 ]; then
          color="\033[31m"  # Red
      elif [ $percentage -ge 70 ]; then
          color="\033[33m"  # Yellow
      fi

      # Build progress bar
      local bar="["
      for ((i=0; i<filled; i++)); do
          bar+="█"
      done
      for ((i=0; i<empty; i++)); do
          bar+="░"
      done
      bar+="]"

      printf "${color}%s %d%%\033[0m" "$bar" "$percentage"
  }

  # Function to format large numbers with K/M suffix
  format_number() {
      local num=$1
      if [ $num -ge 1000000 ]; then
          printf "%.1fM" $(awk "BEGIN {printf \"%.1f\", $num/1000000}")
      elif [ $num -ge 1000 ]; then
          printf "%.1fK" $(awk "BEGIN {printf \"%.1f\", $num/1000}")
      else
          echo "$num"
      fi
  }

  # Function to get session usage information
  get_session_usage() {
      local used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
      local limit=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

      if [ "$limit" -gt 0 ] && [ "$used" -gt 0 ]; then
          local used_fmt=$(format_number $used)
          local limit_fmt=$(format_number $limit)
          local percentage=$((used * 100 / limit))

          # Choose color based on percentage
          local color="\033[32m"  # Green
          if [ $percentage -ge 90 ]; then
              color="\033[31m"  # Red
          elif [ $percentage -ge 70 ]; then
              color="\033[33m"  # Yellow
          fi

          if [ "$SHOW_PROGRESS_BAR" = true ]; then
              # Show with progress bar
              local progress=$(create_progress_bar $used $limit)
              printf " \033[36m[%s/%s %s]\033[0m" "$used_fmt" "$limit_fmt" "$progress"
          else
              # Show without progress bar, just percentage with color
              local pct_display=$(printf "${color}%d%%\033[0m" "$percentage")
              printf " \033[36m[%s/%s %s]\033[0m" "$used_fmt" "$limit_fmt" "$pct_display"
          fi
      fi
  }

  # Change to the current directory for git operations
  cd "$current_dir" 2>/dev/null || true

  # Build the status line
  trimmed_dir=$(trim_directory "$current_dir")
  git_status=$(get_git_status)
  venv_info=$(get_virtualenv)
  custom_indicators=$(get_custom_indicators)
  session_usage=$(get_session_usage)

  MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')

  # Construct the final status line
  status_line=""

  # Add directory
  status_line+="\033[34m$trimmed_dir\033[0m"

  # Add virtual environment if present
  if [ -n "$venv_info" ]; then
      status_line+=" $venv_info"
  fi

  # Add git status if in a git repository
  if [ -n "$git_status" ]; then
      status_line+=" $git_status"
  fi

  # Add custom indicators
  if [ -n "$custom_indicators" ]; then
      status_line+="$custom_indicators"
  fi

  status_line+=" <$MODEL_DISPLAY>"

  # Add session usage information
  if [ -n "$session_usage" ]; then
      status_line+="$session_usage"
  fi

  # Output the final status line
  printf '%b\n' "$status_line"

