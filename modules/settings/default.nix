{ config, lib, ... }:

{
  imports =
    let
      dir = ./.;
      excludes = [ ./default.nix ];
    in
    builtins.filter (
      f:
      !(builtins.elem f excludes)
      && (lib.hasSuffix ".nix" (toString f))
      && !(lib.hasPrefix "_" (builtins.baseNameOf (toString f)))
    ) (lib.filesystem.listFilesRecursive dir);

  config._module.args.settings = config.dotnvim.settings;
}
