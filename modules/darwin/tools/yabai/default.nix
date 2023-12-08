{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.yabai;

  padding = 10;
in
{
  options.shiro.tools.yabai = with types; {
    enable = mkBoolOpt false "Whether or not to install yabai";
  };

  config = mkIf cfg.enable {
    services.yabai = {
      enable = true;
      package = pkgs.yabai;

      config = {
        layout = "bsp";
        window_placement = "second_child";

        external_bar = "main:26:0";
        top_padding = padding;
        right_padding = padding;
        bottom_padding = padding;
        left_padding = padding;
        window_gap = padding;

        window_border = "on";
        window_border_width = 4;
        active_window_border_color = "0xfff5e0dc";
        normal_window_border_color = "0xff6c7086";

        active_window_opacity = 1.0;
        normal_window_opacity = 0.9;
        window_border_radius = 10;

        # mouse settings
        mouse_follows_focus = "on";

        mouse_modifier = "alt";
        mouse_action1 = "move";
        mouse_action2 = "resize";
      };

      extraConfig = ''
        yabai -m mouse_drop_action swap

        # disable specific apps
        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^Calculator$" manage=off
        yabai -m rule --add app="^Karabiner-Elements$" manage=off
        yabai -m rule --add app="^QuickTime Player$" manage=off
        yabai -m rule --add app="^Raycast$" manage=off
        yabai -m rule --add app="^Herd$" manage=off
        yabai -m rule --add app="^LogiTune$" manage=off border=off

        yabai -m rule --add app='Microsoft Teams classic' border=off manage=off
        yabai -m signal --add event=space_changed action='cur_msteams_wid=$(yabai -m query --windows --window | jq -r "if .app == \"Microsoft Teams classic\" and .title == \"Microsoft Teams Notification\" then .id else empty end"); if [ -n $cur_msteams_wid ]; then next_window_id=$(yabai -m query --windows --space | jq -r "map(select(.id != $cur_msteams_wid)) | first | .id // empty"); if [ -n $next_window_id ]; then yabai -m window $next_window_id --focus; fi ; fi'
        yabai -m signal --add event=window_created action='yabai -m query --windows --window $YABAI_WINDOW_ID | jq -e ".\"can-resize\"" || yabai -m window $YABAI_WINDOW_ID --toggle float' app="Microsoft Teams classic"

        # The below signal only works on current master, not in 1.1.2
        # Tries to focus the window under the cursor whenever the MS teams notification gains focus
        # Probably conflicts with mouse follows focus in some ways
        yabai -m signal --add event=window_focused app='^Microsoft Teams$' title='^Microsoft Teams Notification$' action='yabai -m window --focus mouse > /dev/null 2>&1'
      '';
    };

    launchd.user.agents.yabai-load-sa = {
      path = [ pkgs.yabai config.environment.systemPath ];
      command = "/usr/bin/sudo ${pkgs.yabai}/bin/yabai";
      serviceConfig.RunAtLoad = true;
    };
  };
}
