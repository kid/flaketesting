{
  disko = {
    extraRootModules = [ "zfs" ];
    memSize = 16000;
    # devices.disk.vda = {
    #   imageSize = "32G";
    #   device = "/dev/vda";
    #   type = "disk";
    #   content = {
    #     type = "gpt";
    #     partitions = {
    #       boot = {
    #         size = "1M";
    #         type = "EF02";
    #       };
    #       # ESP = {
    #       #   type = "EF00";
    #       #   size = "100M";
    #       #   content = {
    #       #     type = "filesystem";
    #       #     format = "vfat";
    #       #     mountpoint = "/boot";
    #       #   };
    #       # };
    #       root = {
    #         size = "100%";
    #         content = {
    #           type = "filesystem";
    #           format = "ext4";
    #           mountpoint = "/";
    #         };
    #       };
    #     };
    #   };
    # };
    devices = {
      disk.sda = {
        type = "disk";
        device = "/dev/sda";
        imageSize = "12G";
        content = {
          type = "gpt";
          partitions = {
            # boot = {
            # size = "1M";
            # type = "EF02";
            # };
            ESP = {
              start = "1MiB";
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          # mode = "stripe";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/";
        };
      };
    };
  };
}
