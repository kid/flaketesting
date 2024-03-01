# {
#   nixpkgs.hostPlatform = "aarch64-linux";
#   system.stateVersion = "24.05";
# }
{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "22.05";

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Create user "test"
  services.getty.autologinUser = "test";
  users.users.test.isNormalUser = true;

  # Enable paswordless ‘sudo’ for the "test" user
  users.users.test.extraGroups = [ "wheel" ];
  security.sudo.wheelNeedsPassword = false;

  # Make it output to the terminal instead of separate window
  virtualisation.graphics = false;
}
