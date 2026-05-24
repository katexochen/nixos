{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        style = "compact";
        filter_mode_shell_up_key_binding = "session";
        inline_height = 20;
        show_tabs = false;
        show_preview = true;
        enter_accept = true;
        exit_mode = "return-query";
        history_filter = [
          "^exit$"
          "^reboot$"
          "^shutdown$"
          "^poweroff$"
          "^systemctl (reboot|restart|poweroff)$"
          "^ls?$"
          "^clear$"
        ];
        prefers_reduced_motion = true;
      };
    };
  };
}
