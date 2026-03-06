{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.python3;
in
{
  options.shiro.development.languages.python3 = with types; {
    enable = mkBoolOpt false "Whether or not to use Python 3";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (python313.withPackages(p: with p; [
        pygobject3
        pillow
        termcolor
        pyinstaller
      ]))

      python313Packages.pip
    ];
  };
}
