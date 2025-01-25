{ 
  config, 
  lib, 
  pkgs, 
  namespace,
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "tools"
    "git"
  ];

  extraOptions = with lib.types; {
    userName = lib.${namespace}.mkOpt str "kazuto" "The name to configure git with.";
    userEmail = lib.${namespace}.mkOpt str "mail@kazuto.de" "The email to configure git with.";

    programs.git = {
      enable = true;

      userName = userName;
      userEmail = userEmail;

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

  output = {
    home.packages = with pkgs; [ git gh ];
  };
}
