# Set a custom session root path. Default is `$HOME`.
# session_root "~/Projects"

# Create session with specified name if it does not already exist. When no
# argument is given, session name will be based on layout file name.
if initialize_session "dev"; then

  new_window "code"

  # Split: left pane keeps 30%, new right pane gets 70%
  split_h 70

  # Split right pane: center keeps ~40% total, new far-right gets ~30% total
  split_h 43

  # Launch nvim in the center pane
  select_pane 2
  run_cmd "nvim"

  # Focus on nvim (center pane)
  select_pane 2

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
