{ config, lib, options, inputs, outputs, ... }:
with lib;
{
  options = {
    user = mkOption {
      type = types.attrs;
    };

    hm = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = {
    home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.user.name} = mkAliasDefinitions options.hm;
    };
    users.users.${config.user.name} = mkAliasDefinitions options.user;
  };
}
