{ self
, inputs
, lib
, ...
}:
let
  nixosSystem = args:
    (lib.makeOverridable lib.nixosSystem)
      (lib.recursiveUpdate args {
        modules =
          args.modules
        ;
        # ++ [
        #   {
        #     config.nixpkgs.pkgs = lib.mkDefault args.pkgs;
        #     config.nixpkgs.localSystem = lib.mkDefault args.pkgs.stdenv.hostPlatform;
        #   }
        # ];
      });

  hosts = lib.rakeLeaves ./hosts;
  nixosModules = lib.rakeLeaves ./nixos;
  homeManagerModules = lib.rakeLeaves ./homeManager;

  defaultModules = [
    ({ ... }: {
      imports = [
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        nixosModules.desktop.plasma6
        ./shared
        ./homeManager
      ];
    })
  ];
  # defaultModules = [];

  # pkgs.x86-64-linux = import nixpkgs {
  #   inherit lib;
  #   system = "x86-64-linux";
  #   config.allowUnfree = true;
  # };
in
{
  flake = {
    inherit nixosModules homeManagerModules;

    nixosConfigurations = {
      testvm = lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          defaultModules ++ [ hosts.testvm ];
      };
    };
  };
}
