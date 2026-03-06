{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.ollama;
in
{
  options.shiro.development.tools.ollama = with types; {
    enable = mkBoolOpt false "Whether or not to install and enable Ollama.";
  };

  config = mkIf cfg.enable {
    services.ollama.enable = true;
  };
}
