{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        copy-on-select = "clipboard";
        scrollback-limit = 100000000;
        window-padding-x = 20;
        window-padding-y = 20;
        window-padding-balance = true;
        background-opacity = 0.8;
        font-size = 12;
        gtk-titlebar = false;
        window-decoration = false;
        confirm-close-surface = false;
        resize-overlay = "never";
      };
    };
  };
}
