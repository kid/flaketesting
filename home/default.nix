{ pkgs, inputs, ... }:
{
  flake = {
    homeConfigurations.kid = inputs.home-manager.homeManagerConfugration {
      inherit pkgs;
    };
  };
}
