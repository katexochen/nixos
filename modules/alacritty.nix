{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.alacritty = {
      enable = true;
      settings = {
        selection.save_to_clipboard = true;
        window = {
          padding = {
            x = 20;
            y = 20;
          };
          opacity = 0.8;
        };
        font.size = 12;
      };
    };
  };
}
