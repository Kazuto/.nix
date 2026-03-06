{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.aerospace;

  padding = 14;
in
{
  options.shiro.tools.aerospace = with types; {
    enable = mkBoolOpt false "Whether or not to install aerospace";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ aerospace ];

    services.jankyborders = {
      enable = true;
      package = pkgs.jankyborders;

      active_color = "0xFFFAB387";
      width = 8.0;
    };

    shiro.home.configFile."aerospace/aerospace.toml".text = ''
      after-login-command = []

      after-startup-command = [
          'exec-and-forget borders',
          'exec-and-forget sketchybar --reload',
          'layout tiles'
      ]

      start-at-login = true

      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      accordion-padding = 30

      default-root-container-layout = 'tiles'

      default-root-container-orientation = 'auto'

      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
      on-focus-changed = ['move-mouse monitor-lazy-center']

      exec-on-workspace-change = [
          '/bin/bash',
          '-c',
          'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE; sleep 0.1 && sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
      ]

      automatically-unhide-macos-hidden-apps = false

      [workspace-to-monitor-force-assignment]
          1 = 'main'
          2 = 'main'
          3 = 'main'
          4 = 'main'
          5 = 'main'
          6 = 'main'
          "S" = 2
          "T" = 2

      [key-mapping]
          preset = 'qwerty'

      [gaps]
          inner.horizontal = 16
          inner.vertical =   16
          outer.left =       16
          outer.bottom =     16
          outer.top =        [{ monitor.main = 58}, 16]
          outer.right =      16

      [mode.main.binding]
          alt-shift-cmd-ctrl-h = 'focus left'
          alt-shift-cmd-ctrl-j = 'focus down'
          alt-shift-cmd-ctrl-k = 'focus up'
          alt-shift-cmd-ctrl-l = 'focus right'

          alt-shift-h = 'move left'
          alt-shift-j = 'move down'
          alt-shift-k = 'move up'
          alt-shift-l = 'move right'

          alt-minus = 'resize smart -50'
          alt-equal = 'resize smart +50'

          alt-shift-cmd-ctrl-f = 'fullscreen'

          alt-shift-cmd-ctrl-shift-1 = 'workspace 1'
          alt-shift-cmd-ctrl-shift-2 = 'workspace 2'
          alt-shift-cmd-ctrl-shift-3 = 'workspace 3'
          alt-shift-cmd-ctrl-shift-4 = 'workspace 4'
          alt-shift-cmd-ctrl-shift-5 = 'workspace 5'
          alt-shift-cmd-ctrl-shift-6 = 'workspace 6'
          alt-shift-cmd-ctrl-shift-s = 'workspace S'
          alt-shift-cmd-ctrl-shift-t = 'workspace T'

          alt-shift-cmd-ctrl-shift-left = 'workspace prev'
          alt-shift-cmd-ctrl-shift-right = 'workspace next'

          alt-shift-1 = 'move-node-to-workspace 1'
          alt-shift-2 = 'move-node-to-workspace 2'
          alt-shift-3 = 'move-node-to-workspace 3'
          alt-shift-4 = 'move-node-to-workspace 4'
          alt-shift-5 = 'move-node-to-workspace 5'
          alt-shift-6 = 'move-node-to-workspace 6'
          alt-shift-s = 'move-node-to-workspace S'
          alt-shift-t = 'move-node-to-workspace T'

          alt-tab = 'workspace-back-and-forth'
          alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

          alt-shift-semicolon = 'mode service'

      [mode.service.binding]
          esc = ['reload-config', 'mode main']
          r = ['flatten-workspace-tree', 'mode main']
          f = ['layout floating tiling', 'mode main']
          backspace = ['close-all-windows-but-current', 'mode main']

          alt-shift-h = ['join-with left', 'mode main']
          alt-shift-j = ['join-with down', 'mode main']
          alt-shift-k = ['join-with up', 'mode main']
          alt-shift-l = ['join-with right', 'mode main']

      [[on-window-detected]]
          if.app-id = 'org.mozilla.firefox'
          if.window-title-regex-substring = 'Work'
          run = "move-node-to-workspace 1"

      [[on-window-detected]]
          if.app-id = 'org.mozilla.firefox'
          if.window-title-regex-substring = 'Private'
          run = "move-node-to-workspace 5"

      [[on-window-detected]]
          if.app-id = 'com.mitchellh.ghostty'
          run = "move-node-to-workspace 2"

      [[on-window-detected]]
          if.app-id = 'de.beyondco.tinkerwell'
          run = "move-node-to-workspace 2"

      [[on-window-detected]]
          if.app-id = 'com.tinyapp.TablePlus'
          run = "move-node-to-workspace 3"

      [[on-window-detected]]
          if.app-id = 'com.usebruno.app'
          run = "move-node-to-workspace 4"

      [[on-window-detected]]
          if.app-id = 'net.whatsapp.WhatsApp'
          run = "move-node-to-workspace 6"

      [[on-window-detected]]
          if.app-id = 'org.whispersystems.signal-desktop'
          run = "move-node-to-workspace 6"

      [[on-window-detected]]
          if.app-id = 'com.spotify.client'
          run = "move-node-to-workspace S"

      [[on-window-detected]]
          if.app-id = 'com.microsoft.teams2'
          run = "move-node-to-workspace T"
    '';
  };
}
