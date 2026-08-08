{ config, lib, profile, ... }:

lib.mkIf profile.hardware.nvidiaPrime.enable {
  environment.systemPackages = [
    config.hardware.nvidia.package
  ];

  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-compositor-vram.json" = {
    text = builtins.toJSON {
      rules = [
        {
          pattern.feature = "procname";
          pattern.matches = "niri";
          profile = "Limit Free Buffer Pool On Wayland Compositors";
        }
        {
          pattern.feature = "procname";
          pattern.matches = "Hyprland";
          profile = "Limit Free Buffer Pool On Wayland Compositors";
        }
      ];
      profiles = [{
        name = "Limit Free Buffer Pool On Wayland Compositors";
        settings = [{
          key = "GLVidHeapReuseRatio";
          value = 0;
        }];
      }];
    };
  };

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

      amdgpuBusId = profile.hardware.nvidiaPrime.amdgpuBusId;
      nvidiaBusId = profile.hardware.nvidiaPrime.nvidiaBusId;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
}