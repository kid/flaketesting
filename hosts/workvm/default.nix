{ self, pkgs, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    # inputs.nixos-generators
    # inputs.nixos-generators.nixosModules.all-formats
    # inputs.home-manager.nixosModules.home-manager
    # "${modulesPath}/virtualisation/qemu-vm.nix"
    ./disko.nix
    ./home.nix
    ./vm.nix
    # ./graphics.nix
    # self.nixosModules.desktop
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

  # virtualisation = {
  #   useEFIBoot = true;
  #   useBootLoader = true;
  #   graphics = false;
  #   qemu.options = [
  #     "-vga virtio"
  #     "-display gtk,gl=on"
  #   ];
  # };

  hardware.opengl.enable = true;

  # virtualisation.useEFIBoot = true;
  # virtualisation.useBootLoader = true;

  # services.xserver = {
  #   enable = true;
  #
  #   displayManager = {
  #     autoLogin = {
  #       enable = true;
  #       user = "test";
  #     };
  #     sddm = {
  #       enable = true;
  #       wayland.enable = true;
  #     };
  #   };
  #   desktopManager = {
  #     plasma6.enable = true;
  #   };
  # };

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.grub.devices = ["/dev/sda" "/dev/vda"];
  # boot.loader.grub = {
  #   zfsSupport = true;
  # };
  networking.hostId = "8425e349";


  boot = {
    supportedFilesystems = [ "zfs" ];
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  # format = "disko-efi";
  # customFormats.disko-efi = { config, inputs, modulesPath, ... }: {
  #   formatAttr = "disko-efi";
  #   imports = [
  #       "${toString modulesPath}/profiles/qemu-guest.nix"
  #   ];
  #   system.build.disko-efi = inputs.disko.lib.makeDiskoImages {
  #
  #   };
  # };
}
