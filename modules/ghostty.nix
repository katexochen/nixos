{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs = {
      ghostty = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          shell-integration = "none";
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

      # Enable ghostty's SSH integration so TERM=xterm-ghostty stops leaking to
      # remote hosts. ghostty.bash only defines its `ssh` wrapper when GHOSTTY_SHELL_FEATURES
      # contains an ssh-* feature; ghostty normally exports that during shell
      # integration setup, but shell-integration = "none" skips setup entirely
      # (setup() is never called) so the var stays unset. Set it here at
      # order 100, just before HM sources ghostty.bash (order 101).
      bash.initExtra = lib.mkOrder 100 ''
        if [[ -n "''${GHOSTTY_RESOURCES_DIR}" ]]; then
          GHOSTTY_SHELL_FEATURES="ssh-env,ssh-terminfo,cursor,title"
        fi
      '';
    };
  };
}
