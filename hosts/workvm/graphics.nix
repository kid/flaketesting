{
  # virtualisation = {
  #   qemu.options = [
  #     "-vga virtio"
  #     "-display gtk,gl=on"
  #   ];
  # };


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
