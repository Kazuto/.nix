{ lib, namespace, ... }:

with lib; 
rec {
  mkOpt = 
    type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = 
    type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  enabled = { enable = true; };

  disabled = { enable = false; };

  mkModule =
    {
      config,
      path,
      output,
      default ? false,
      extraOptions ? { },
    }:
    let
      realPath = [ namespace ] ++ path;
      mergedOptions = lib.mergeAttrs { enable = mkBoolOpt' default; } extraOptions;
    in
    {
      options = lib.setAttrByPath realPath mergedOptions;
      config = lib.mkIf (lib.attrByPath (realPath ++ [ "enable" ]) false config) output;
    };
}
