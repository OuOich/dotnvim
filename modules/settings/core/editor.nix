{ lib, ... }:

{
  options.dotnvim.settings.core.keymaps = {
    leader = lib.mkOption {
      type = lib.types.str;
      default = " ";
      description = "Leader key used by dotnvim key mappings.";
    };
  };
}
