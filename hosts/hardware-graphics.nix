{ config, lib, profile, ... }:

lib.mkIf profile.nvidiaPrime.enable {
  environment.systemPackages = [
    config.hardware.nvidia.package
  ];

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = profile.nvidiaPrime.amdgpuBusId;
      nvidiaBusId = profile.nvidiaPrime.nvidiaBusId;
    };
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
}