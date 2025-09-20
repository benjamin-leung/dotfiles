# Tmux sessionizer function for nushell
def tmux-sessionizer [selected?: string] {
  let selected = if ($selected | is-empty) {
    # Find projects and worktrees, then combine them
    let projects = (ls ~/Code | where type == dir | get name)
    # let worktrees = (ls ~/code/worktrees/*/ | where type == dir | get name)
    # let merged = ($projects | append $worktrees)
    let merged = ($projects | append "/Users/benjaminleung/Code")
    
    # Use fzf to select from the merged list
    ($merged | str join "\n" | fzf | str trim)
  } else {
    $selected
  }
  
  # Exit if no selection was made
  if ($selected | is-empty) {
    return
  }
  
  # Create session name by replacing dots with underscores
  let parent_directory = ($selected | path dirname | str replace -a '.' '_')
  let current_directory = ($selected | path basename | str replace -a '.' '_')
  let selected_name = $"($parent_directory)/($current_directory)"
  
  # Check if tmux is running
  let tmux_running = (do { pgrep tmux } | complete | get exit_code) == 0
  
  # If not in tmux and tmux isn't running, start new session
  if ($env.TMUX? | is-empty) and (not $tmux_running) {
    tmux new-session -s $selected_name -c $selected
    return
  }
  
  # Create session if it doesn't exist
  let session_exists = (do { tmux has-session -t $selected_name } | complete | get exit_code) == 0
  if not $session_exists {
    tmux new-session -ds $selected_name -c $selected
  }
  
  # Attach or switch to session
  if ($env.TMUX? | is-empty) {
    tmux attach-session -t $selected_name
  } else {
    tmux switch-client -t $selected_name
  }
}
