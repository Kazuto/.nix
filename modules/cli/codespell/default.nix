{ lib, config, ... }:

let
  cfg = config.shiro.cli.codespell;
in
{
  options.shiro.cli.codespell = with types; {
    enable = mkBoolOpt false "Whether or not to install Codespell";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ codespell ];
  };
}
