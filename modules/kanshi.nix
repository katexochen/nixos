{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;

  dellu2717 = "Dell Inc. DELL U2717D J0XYN8AOA5ML";
  dellu2724 = "Dell Inc. DELL U2724D 9KP0D84";
  dellaw25 = "Dell Inc. AW2521HFA 7CWTL03";
  p14s = "Lenovo Group Limited B140UAN02.7  Unknown";
  l14 = "Lenovo Group Limited L15 U133MM45";
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} =
      { lib, ... }:
      {
        home.activation.kanshiReload = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
          if ${pkgs.systemd}/bin/systemctl --user --quiet is-active kanshi.service 2>/dev/null; then
            $DRY_RUN_CMD ${pkgs.kanshi}/bin/kanshictl reload 2>/dev/null || true
          fi
        '';

        services.kanshi = {
          enable = true;
          settings = [
            {
              profile.name = "home-1-ext";
              profile.outputs = [
                {
                  criteria = dellu2717;
                  status = "enable";
                  position = "0,0";
                }
                {
                  criteria = p14s;
                  status = "enable";
                  position = "2560,240";
                }
              ];
            }
            {
              profile.name = "home-2-ext";
              profile.outputs = [
                {
                  criteria = dellu2724;
                  status = "enable";
                  position = "0,0";
                }
                {
                  criteria = dellu2717;
                  status = "enable";
                  position = "2560,0";
                }
                {
                  criteria = p14s;
                  status = "enable";
                  position = "5120,240";
                }
              ];
            }
            {
              profile.name = "undoced";
              profile.outputs = [
                {
                  criteria = p14s;
                  status = "enable";
                  position = "0,0";
                }
              ];
            }
            {
              profile.name = "mobile-external";
              profile.outputs = [
                {
                  criteria = l14;
                  status = "enable";
                  position = "0,0";
                }
                {
                  criteria = p14s;
                  status = "enable";
                  position = "1920,0";
                }
              ];
            }
            {
              profile.name = "gf";
              profile.outputs = [
                {
                  criteria = dellaw25;
                  status = "enable";
                  position = "0,0";
                }
                {
                  criteria = p14s;
                  status = "enable";
                  position = "0,1080";
                }
              ];
            }
          ];
        };
      };
  };
}
