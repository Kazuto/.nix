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
    "php81"
  ];

  output = {
    environment.systemPackages = with pkgs;  [
      (php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug imagick
        ]));
        extraConfig = ''
          memory_limit = 8G
          IDE Key = nvim
          xdebug.mode = debug
        '';
      })

      php81Packages.composer
      php81Extensions.imagick
    ];
  };
}
