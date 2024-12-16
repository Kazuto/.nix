{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.fonts;
in
{
  options.shiro.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        font-awesome
        google-fonts
      ] ++ cfg.fonts;
  };
}
