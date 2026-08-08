{ profile, lib, ... }:
{
  boot.kernelParams = [
    "quiet"
    "splash"
  ] ++ lib.optionals profile.workarounds.disablePsr [
    "amdgpu.dcdebugmask=0x10"
  ];

  boot = {
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    loader = {
      timeout = 0;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = profile.system.nix.bootGenerationsLimit;
      };

      grub.enable = false;
    };
  };
}