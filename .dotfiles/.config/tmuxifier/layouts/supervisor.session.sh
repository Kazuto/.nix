# Set a custom session root path. Default is `$HOME`.
session_root "$PROJECT_ROOT/Smake"

if initialize_session "supervisor"; then

  # ── Window 1: supervisor ──
  window_root "$PROJECT_ROOT/Smake/production-server-supervisor"
  new_window "supervisor"

  split_h 70
  split_h 43

  # Left pane: npm run dev
  select_pane 1
  run_cmd "npm run dev"

  # Right pane: claude
  select_pane 3
  run_cmd "claude"

  # Focus on nvim (center)
  select_pane 2
  run_cmd "nvim"

  # ── Window 2: server ──
  window_root "$PROJECT_ROOT/Smake/production-server-v2"
  new_window "server"

  split_h 70
  split_h 43

  # Left pane: npm run dev
  select_pane 1
  run_cmd "npm run dev"

  # Right pane: claude
  select_pane 3
  run_cmd "claude"

  # Focus on nvim (center)
  select_pane 2
  run_cmd "nvim"

  # Start on the first window
  select_window 1

fi

finalize_and_go_to_session
