{ inputs, outputs, modulesPath, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

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
  # virtualisation.graphics = false;
  virtualisation = {
    # useEFIBoot = true;
    # useBootLoader = true;
    qemu.options = [
      "-vga virtio"
      "-display gtk,gl=on"
    ];
  };

  hardware.opengl.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.test = import ../../homes/home.nix;
  };

  services.xserver = {
    enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "test";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager = {
      plasma6.enable = true;
    };
  };
}
