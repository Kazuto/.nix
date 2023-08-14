{ lib, config, ... }:

let
  cfg = config.shiro.cli.editorconfig-checker;
in
{
  options.shiro.cli.editorconfig-checker = with types; {
    enable = mkBoolOpt false "Whether or not to install EditorConfig Checker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ editorconfig-checker ];
  };
}
