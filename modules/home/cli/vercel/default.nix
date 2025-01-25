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
    environment.systemPackages = with pkgs; [ nodePackages.vercel ];
  };
}
