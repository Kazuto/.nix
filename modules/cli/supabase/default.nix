{ lib, config, ... }:

let
  cfg = config.shiro.cli.supabase;
in
{
  options.shiro.cli.supabase = with types; {
    enable = mkBoolOpt false "Whether or not to install supabase";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ supabase-cli ];
  };
}
