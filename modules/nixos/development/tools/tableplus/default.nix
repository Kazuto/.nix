{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.tableplus;
in
{
  options.shiro.development.tools.tableplus = with types; {
    enable = mkBoolOpt false "Whether or not to install TablePlus.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.appimageTools.wrapType2 {
        name = "tableplus";
        src = pkgs.fetchurl {
          url = "https://github.com/TablePlus/TablePlus-Linux/releases/download/build-472/TablePlus.AppImage";
          sha256 = lib.fakeHash;
        };
      })
    ];
  };
}
