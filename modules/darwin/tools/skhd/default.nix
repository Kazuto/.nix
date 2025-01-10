{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.skhd;

  yabai = "${pkgs.yabai}/bin/yabai";
  kitty = "${pkgs.kitty}/bin/kitty";

  hyperKey = "shift + ctrl + alt + cmd";

  keybinds = ''
    # -- Changing Window Focus --

    # change window focus within space
    ${hyperKey} - j : ${yabai} -m window --focus south
    ${hyperKey} - k : ${yabai} -m window --focus north
    ${hyperKey} - h : ${yabai} -m window --focus west
    ${hyperKey} - l : ${yabai} -m window --focus east

    #change focus between external displays (left and right)
    #alt - s: ${yabai} -m display --focus west
    #alt - g: ${yabai} -m display --focus east

    # -- Modifying the Layout --

    # rotate layout clockwise
    shift + alt - r : ${yabai} -m space --rotate 270

    # flip along y-axis
    shift + alt - y : ${yabai} -m space --mirror y-axis

    # flip along x-axis
    shift + alt - x : ${yabai} -m space --mirror x-axis

    # toggle window float
    shift + alt - t : ${yabai} -m window --toggle float --grid 4:4:1:1:2:2


    # -- Modifying Window Size --

    # maximize a window
    ${hyperKey} - f : ${yabai} -m window --toggle zoom-fullscreen

    # balance out tree of windows (resize to occupy same area)
    ${hyperKey} - e : ${yabai} -m space --balance

    # -- Moving Windows Around --

    # swap windows
    cmd + shift - j : ${yabai} -m window --swap south
    cmd + shift - k : ${yabai} -m window --swap north
    cmd + shift - h : ${yabai} -m window --swap west
    cmd + shift - l : ${yabai} -m window --swap east

    # move split
    ctrl + alt - j : ${yabai} -m window --warp south
    ctrl + alt - k : ${yabai} -m window --warp north
    ctrl + alt - h : ${yabai} -m window --warp west
    ctrl + alt - l : ${yabai} -m window --warp east

    # move window to display left and right
    # shift + alt - s : ${yabai} -m window --display west; yabai -m display --focus west;
    # shift + alt - g : ${yabai} -m window --display east; yabai -m display --focus east;

    # move window to prev and next space
    cmd + alt - p : ${yabai} -m window --space prev;
    cmd + alt - n : ${yabai} -m window --space next;

    # move window to space #
    cmd + shift - 1 : ${yabai} -m window --space 1;
    cmd + shift - 2 : ${yabai} -m window --space 2;
    cmd + shift - 3 : ${yabai} -m window --space 3;
    cmd + shift - 4 : ${yabai} -m window --space 4;
    cmd + shift - 5 : ${yabai} -m window --space 5;
    cmd + shift - 6 : ${yabai} -m window --space 6;
    cmd + shift - 7 : ${yabai} -m window --space 7;
    cmd + shift - 8 : ${yabai} -m window --space 8;
    cmd + shift - 9 : ${yabai} -m window --space 9;

    cmd - return : open -a ghostty -n
  '';
in
{
  options.shiro.tools.skhd = with types; {
    enable = mkBoolOpt false "Whether or not to install skhd";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ skhd ];

    environment.etc."skhdrc".text = keybinds;

    launchd.user.agents.skhd = {
      path = [ config.environment.systemPath ];

      serviceConfig = {
        ProgramArguments = [ "${pkgs.skhd}/bin/skhd" "-c" "/etc/skhdrc" ];
        KeepAlive = true;
        ProcessType = "Interactive";
      };
    };
  };
}
