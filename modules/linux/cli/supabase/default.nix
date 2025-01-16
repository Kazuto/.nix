{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.supabase;
in
{
  options.${namespace}.cli.supabase = with types; {
    enable = mkBoolOpt false "Whether or not to install supabase";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ supabase-cli ];
  };
}
