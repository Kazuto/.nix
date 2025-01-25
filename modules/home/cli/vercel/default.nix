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
    "cli"
    "vercel"
  ];

  output = {
    home.packages = with pkgs; [ nodePackages.vercel ];
  };
}
