_: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      update_check = false;
      style = "compact";
      filter_mode_shell_up_key_binding = "session";
      inline_height = 20;
      show_tabs = false;
      show_preview = true;
      history_filter = [
        "^exit$"
        "^reboot$"
        "^shutdown$"
        "^poweroff$"
        "^systemctl (reboot|restart|poweroff)$"
        "^ls?$"
        "^clear$"
      ];
    };
  };
}
