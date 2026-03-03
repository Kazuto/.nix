{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.asciinema;
in
{
  options.shiro.cli.asciinema = with types; {
    enable = mkBoolOpt false "Whether or not to install asciinema and agg.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ asciinema agg ];
  };
}
