{ self
, inputs
, ...
}: {
  debug = true;

  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.devshell.flakeModule
    inputs.treefmt-nix.flakeModule
    ../homes
    ../hosts
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  flake = {
    packages = {
      x86_64-linux.hello = inputs.nixpkgs.legacyPackages.x86_64-linux.hello;
      x86_64-linux.workvm = self.nixosConfigurations.workvm.config.system.build.vm;
      aarch64-linux.workvm = self.nixosConfigurations.workvm-aarch64.config.system.build.vm;
      aarch64-darwin.workvm = self.nixosConfigurations.workvm-darwin.config.system.build.vm;
    };

    githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.checks;
    };
  };

  perSystem =
    { config
    , pkgs
    , system
    , self'
    , inputs'
    , ...
    }: {
      # Avoid this if possible
      # _module.args.pkgs = import inputs.nixpkgs {
      #   inherit system;
      #   overlays = [
      #     self.overlays.default
      #   ];
      # };
      # overlayAttrs = {
      #   inherit (config.packages) update-input;
      # };

      devshells.default = {
        packages = [
          pkgs.nil
          self'.packages.update-input
          config.treefmt.build.wrapper
          inputs'.home-manager.packages.default
        ] ++ builtins.attrValues config.treefmt.build.programs;
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixpkgs-fmt.enable = true;
          yamlfmt.enable = true;
        };
      };

      packages.update-input = pkgs.writeShellScriptBin "update-input" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail
        input=$(nix flake metadata --json | ${pkgs.jq}/bin/jq -r '.locks.nodes.root.inputs[]' | ${pkgs.fzf}/bin/fzf)
        nix flake lock --update-input $input --commit-lock-file
      '';

      checks = self'.packages;
    };
}
