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
    "supabase"
  ];

  output = {
    home.packages = with pkgs; [ supabase-cli ];
  };
}