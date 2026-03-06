{ lib, ... }:

with lib;
with lib.shiro;
{
  shiro.layouts.workstation = enabled;
}
