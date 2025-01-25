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
    environment.systemPackages = with pkgs; [ supabase-cli ];
  };
}