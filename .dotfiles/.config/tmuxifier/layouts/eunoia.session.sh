# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Privat"

if initialize_session "eunioa"; then

  # ── Window 1: supervisor ──
  new_window "supervisor"
  window_root "$PROJECT_ROOT/Privat/eunioa"

  split_h 70
  split_h 43

  # Left pane: npm run dev
  select_pane 1
  run_cmd "npm run storybook"

  # Right pane: claude
  select_pane 3
  run_cmd "claude"

  # Focus on nvim (center)
  select_pane 2
  run_cmd "nvim"

fi

finalize_and_go_to_session
