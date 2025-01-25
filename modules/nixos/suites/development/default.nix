{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "suites"
    "development"
  ];

  output = {
    shiro = {
      cli = {
        commitizen = enabled;
        curl = enabled;
        gum = enabled;
        neovim = enabled;
        ngrok = enabled;
        phpstan = enabled;
        pre-commit = enabled;
        supabase = enabled;
        vercel = enabled;
        # wget = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        beekeeper = enabled;
        bruno = enabled;
        dbeaver = enabled;
        insomnia = enabled;
        gitkraken = enabled;
        vscode = enabled;
      };

      development.languages = {
        go = enabled;
        nodejs20 = enabled;
        php81 = enabled;
        python311 = enabled;
      };

      tools = {
        git = enabled;
      };
    };
  };
}
