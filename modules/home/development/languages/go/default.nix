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
    environment.systemPackages = with pkgs;  [
      go
      gotools
      golangci-lint
      ginkgo
      mockgen
    ];
  };
}
