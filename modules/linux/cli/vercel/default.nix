{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.vercel;
in
{
  options.${namespace}.cli.vercel = with types; {
    enable = mkBoolOpt false "Whether or not to install vercel cli";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nodePackages.vercel ];
  };
}
