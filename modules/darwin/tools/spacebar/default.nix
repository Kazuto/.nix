{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.spacebar;
in
{
  options.shiro.tools.spacebar = with types; {
    enable = mkBoolOpt false "Whether or not to install spacebar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ spacebar ];

    services.spacebar = {
      enable = true;
      package = pkgs.spacebar;

      config = {
        position                   = "top";
        display                    = "main";
        height                     = 26;
        title                      = "on";
        spaces                     = "on";
        clock                      = "on";
        power                      = "on";
        padding_left               = 20;
        padding_right              = 20;
        spacing_left               = 25;
        spacing_right              = 15;
        text_font                  = ''"JetBrainsMono Nerd Font:Regular:13.0"'';
        icon_font                  = ''"JetBrainsMono Nerd Font:Regular:13.0"'';
        background_color           = "0xff1e1e2e";
        foreground_color           = "0xffcdd6f4";
        power_icon_color           = "0xffcd950c";
        battery_icon_color         = "0xffd75f5f";
        dnd_icon_color             = "0xffa8a8a8";
        clock_icon_color           = "0xffa8a8a8";
        power_icon_strip           = " ";
        space_icon                 = "";
        space_icon_strip           = "󰖟  󰊤 󰆼 󱂛    󰓇";
        spaces_for_all_displays    = "off";
        display_separator          = "off";
        display_separator_icon     = "";
        space_icon_color           = "0xfffab387";
        space_icon_color_secondary = "0xff78c4d4";
        space_icon_color_tertiary  = "0xfffff9b0";
        clock_icon                 = "";
        dnd_icon                   = "";
        clock_format               = ''"%d.%m.%y %R"'';

        right_shell                = "off";
        right_shell_icon           = "";
        right_shell_command        = "whoami";
      };
    };
  };
}
