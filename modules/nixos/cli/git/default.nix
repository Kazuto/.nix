{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.git;
  user = config.shiro.user;
in
{
  options.shiro.cli.git = with types; {
    enable = mkBoolOpt false "Whether or not to use git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git gh ];

    shiro.home.extraOptions = {
      programs.git = {
        enable = true;

        inherit (cfg) userName userEmail;

        extraConfig = {
          init = { defaultBranch = "master"; };
          push = { autoSetupRemote = true; };
        };
      };

      programs.zsh.shellAliases = {
        gaa = "git add .";
        gfa = "git fetch --all";
      };

      programs.bash.shellAliases = {
        gaa = "git add .";
        gfa = "git fetch --all";
      };
    };
  };
}
