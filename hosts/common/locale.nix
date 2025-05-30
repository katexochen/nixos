{ lib, ... }:

{
  i18n = {
    extraLocaleSettings = {
      LC_COLLATE = "C.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
  location.provider = "geoclue2";
  time.timeZone = lib.mkDefault "UTC";
}
