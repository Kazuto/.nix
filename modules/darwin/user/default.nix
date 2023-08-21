{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.user;
in
{
  options.shiro.user = with types; {
    name = mkOpt str "kazuto" "The name to use for the user account.";
    fullName = mkOpt str "Kai Mayer" "The full name of the user.";
    email = mkOpt str "mail@kazuto.de" "The email of the user.";
  };

  config = {
    users.users.${cfg.name} = {
      uid = mkIf (cfg.uid != null) cfg.uid;

      shell = pkgs.zsh;
    };
  };
}


