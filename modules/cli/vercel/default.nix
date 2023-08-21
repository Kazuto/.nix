{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.vercel;
in
{
  options.shiro.cli.vercel = with types; {
    enable = mkBoolOpt false "Whether or not to install vercel cli";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nodePackages.vercel ];
  };
}
