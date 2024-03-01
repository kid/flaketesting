# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.9)
{
  # A helpful description of your flake
  description = "My NixOS Configuration as a Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://kidibox.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "kidibox.cachix.org-1:BN875x9JUW61souPxjf7eA5Uh2k3A1OSA1JIb/axGGE="
    ];
  };

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        debug = true;

        imports = [
          inputs.devshell.flakeModule
          inputs.treefmt-nix.flakeModule
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        flake = {
          nixosConfigurations = {
            workvm = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./hosts/workvm
              ];
            };
            workvm-aarch64 = inputs.nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                ./hosts/workvm
              ];
            };
            workvm-darwin = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./hosts/workvm
                { virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin; }
              ];
            };
          };

          packages = {
            x86_64-linux.hello = inputs.nixpkgs.legacyPackages.x86_64-linux.hello;
            x86_64-linux.workvm = self.nixosConfigurations.workvm.config.system.build.vm;
            aarch64-linux.workvm = self.nixosConfigurations.workvm-aarch64.config.system.build.vm;
            aarch64-darwin.workvm = self.nixosConfigurations.workvm-darwin.config.system.build.vm;
          };

          githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
            checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.packages;
          };
        };

        perSystem = { config, pkgs, ... }: {
          devshells.default = {
            packages = [
              pkgs.nil
              config.treefmt.build.wrapper
            ] ++ builtins.attrValues config.treefmt.build.programs;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixpkgs-fmt.enable = true;
              yamlfmt.enable = true;
            };
          };
        };
      };
}
