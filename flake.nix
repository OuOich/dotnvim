{
  description = "Cheng's Neovim (Nixvim) configuration!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts/main";

    nixvim.url = "github:nix-community/nixvim/main";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/master";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./flake/shell.nix
        ./flake/checks.nix
      ];

      flake = {
        nixvimModules.default =
          { pkgs, ... }:
          {
            _module.args.lib' = import ./lib { inherit (pkgs) lib; };

            imports = [
              ./options
              ./config
            ];
          };

        homeModules.default = import ./modules/home-manager.nix {
          inherit inputs self;
        };

        overlays = {
          default = import ./overlays { inherit (nixpkgs) lib; };
        };
      };

      perSystem =
        {
          config,
          system,
          ...
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.neovim-nightly-overlay.overlays.default
              self.overlays.default
            ];
          };

          nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = self.nixvimModules.default;
          };
        in
        {
          _module.args.pkgs = pkgs;

          packages = {
            default = nvim;
          };

          apps = {
            default = config.apps.nvim;

            nvim = {
              type = "app";
              program = "${nvim}/bin/nvim";

              meta = {
                description = "Neovim with Cheng's configuration.";
              };
            };

            nixvim-print-init = {
              type = "app";
              program = "${nvim}/bin/nixvim-print-init";

              meta = {
                description = "Debug print generated `init.lua` from Nixvim.";
              };
            };
          };
        };
    };
}
