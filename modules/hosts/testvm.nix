{ config, ... }:
{
  system.stateVersion = "24.05";

  user = {
    name = "kid";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    initialPassword = "foo";
  };

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Create user "test"
  services.getty.autologinUser = config.user.name;

  # Enable passwordless ‘sudo’ for the "test" user
  security.sudo.wheelNeedsPassword = false;

  virtualisation.vmVariant = {
    user = config.user;
    virtualisation = {
      memorySize = 2048;
      cores = 2;
    };
  };
}
