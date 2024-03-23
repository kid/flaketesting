{ config, lib, modulesPath, pkgs, ... }:
let
  qemu-common = import "${modulesPath}/../lib/qemu-common.nix" { inherit lib pkgs; };
  qemu = pkgs.qemu_kvm;
  hostPkgs = pkgs; # config.virtualisation.host.pkgs;
  startVM =
    ''
      #!${hostPkgs.runtimeShell}

      export PATH=${lib.makeBinPath [ hostPkgs.coreutils ]}''${PATH:+:}$PATH

      set -e

      script_dir="$(dirname "''${BASH_SOURCE[0]}")"
      images_dir="''${script_dir}/../images"

      tmp_img="$(mktemp)"

      cp "$images_dir/sda.raw" "$tmp_img"

      ${qemu-common.qemuBinary qemu} \
        -name ${config.system.name} \
        -m 4096 \
        -device virtio-rng-pci \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        -drive "format=raw,file=$tmp_img" \
        -net nic,netdev=user.0,model=virtio \
        -netdev user,id=user.0 \
        -vga virtio -display gtk,gl=on "$@"

      rm "$tmp_img"
    '';
in
{
  boot.zfs.devNodes = "/dev/disk/by-uuid";

  system.build.diskovm = hostPkgs.runCommand
    "run-nixos-vm"
    {
      preferLocalBuild = true;
      metaMainProgram = "run-${config.system.name}-vm";
    }
    ''
      mkdir -p $out/bin
      ln -s ${config.system.build.diskoImages} $out/images
      ln -s ${hostPkgs.writeScript "run-nixos-vm" startVM} $out/bin/run-${config.system.name}-vm
    '';
}
