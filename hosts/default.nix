{ inputs, ... }:
{
  flake = {
    nixosConfigurations = {
      workvm = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./workvm
        ];
      };
      workvm-aarch64 = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [
          ./workvm
        ];
      };
      workvm-darwin = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./workvm
          { virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin; }
        ];
      };
    };
  };
}
