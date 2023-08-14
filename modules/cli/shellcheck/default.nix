{ lib, config, ... }:

let
  cfg = config.shiro.cli.shellcheck;
in
{
  options.shiro.cli.shellcheck = with types; {
    enable = mkBoolOpt false "Whether or not to install shellcheck";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ shellcheck ];
  };
}
