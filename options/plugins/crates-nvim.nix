{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "crates-nvim";
  moduleName = "crates";

  maintainers = [ ];
}
