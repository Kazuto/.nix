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
           gd imagick opcache pcov redis xdebug
        ]));
        extraConfig = ''
          memory_limit = 8G
          IDE Key = nvim
          xdebug.mode = debug
        '';
      })

      imagemagick
      php81Extensions.imagick

      php81Packages.composer
      blade-formatter
    ];
  };
}
