{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.meilisearch;
in
{
  options.shiro.development.tools.meilisearch = with types; {
    enable = mkBoolOpt false "Whether or not to install meilisearch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ meilisearch ];
  };
}


