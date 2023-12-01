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

        yabai -m rule --add app='Microsoft Teams' border=off manage=off
        # yabai -m rule --add app='^Microsoft Teams$' title='^Meeting$' border=off manage=off

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
