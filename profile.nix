{
  system = {
    hostname = "nixSO";
    timeZone = "Europe/Paris";
    locale = "en_US.UTF-8";
    consoleKeyMap = "fr";
  };

  user = {
    username = "so";
    repoPath = "/home/so/nixSO";
  };

  git = {
    name = "somnvl";
    email = "186089420+somnvl@users.noreply.github.com";
  };

  cursor = {
    theme = "miku";
    size = 50;
  };

  features = {
    docker = true;

    gc = {
      automatic = true;
      dates = "weekly";
      retention = "30d";
      optimiseAutomatic = true;
    };

    devTools  = true;
    cDev      = true;
    pythonDev = true;
    goDev     = true;
    wailsDev  = true;
  };
}