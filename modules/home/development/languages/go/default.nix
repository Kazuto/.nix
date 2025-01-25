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
    "go"
  ];

  output = {
    home.packages = with pkgs;  [
      go
      gotools
      golangci-lint
      ginkgo
      mockgen
    ];
  };
}
