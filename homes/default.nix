{ self, inputs, outputs, ... }:
{
  flake = {
    homeConfigurations.kid = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs outputs; };
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home.nix
        {
          home.username = "kid";
          home.homeDirectory = "/Users/kid";
        }
      ];
    };

    checks.x86_64-linux.home-configuration-kid = self.homeConfigurations.kid.activationPackage;
  };
}
