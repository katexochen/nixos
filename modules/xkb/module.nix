{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.my.role == "client") {
    services.xserver.xkb = {
      layout = "us-custom,de-custom";
      options = "ctrl:nocaps,grp:win_space_toggle";
      extraLayouts = {
        us-custom = {
          description = "US custom layout";
          languages = [ "eng" ];
          symbolsFile = pkgs.copyPathToStore ./us-custom;
        };
        de-custom = {
          description = "DE custom layout";
          languages = [ "ger" ];
          symbolsFile = pkgs.copyPathToStore ./de-custom;
        };
      };
    };
  };
}
