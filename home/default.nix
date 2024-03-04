{ self, inputs, outputs, ... }:
{
  flake = {
    homeConfigurations.kid = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs outputs; };
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./home.nix
      ];
    };

    checks.x86_64-linux.home-configuration-kid = self.homeConfigurations.kid.activationPackage;
  };
}
