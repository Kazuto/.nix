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
    "development"
    "languages"
    "nodejs20"
  ];

  output = {
    home.packages = with pkgs;  [
      nodejs_20
      nodePackages.eslint_d
      nodePackages.postcss
      nodePackages.vercel
      vscode-extensions.vue.volar
    ];
  };
}


