{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {

    home-manager.users.${user}.programs = {
      atuin = {
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
          update_check = false;
          history_filter = [
            "^exit$"
            "^reboot$"
            "^shutdown$"
            "^poweroff$"
            "^systemctl (reboot|restart|poweroff)$"
            "^ls?( .*)?$"
            "^cd( .*)?$"
            "^clear$"
          ];
          prefers_reduced_motion = true;
        };
      };
      # Workaround for bash-preexec 0.6.0 on bash >= 5.1: when PROMPT_COMMAND is
      # already an array at source time (as ghostty 1.x leaves it), an indexing
      # bug in __bp_install_after_session_init lets __bp_install_string get
      # wedged in a later array element, where its `trap - DEBUG` fires on every
      # prompt and kills atuin's command recording. Coercing PROMPT_COMMAND to
      # scalar here sidesteps the bug. Order 500 lands between ghostty's source
      # (order 101) and atuin's bash-preexec source (default ~1000).
      # Fixed upstream by rcaloras/bash-preexec@097b421 (2025-01-09); drop this
      # workaround once nixpkgs ships a bash-preexec release including it.
      # upstream issue: https://github.com/rcaloras/bash-preexec/issues/188
      bash.initExtra = lib.mkOrder 500 ''
        if [[ "$(declare -p PROMPT_COMMAND 2>&1)" == "declare -a"* ]]; then
          _prompt_command_joined="''${PROMPT_COMMAND[*]}"
          unset PROMPT_COMMAND
          PROMPT_COMMAND="$_prompt_command_joined"
          unset _prompt_command_joined
        fi
      '';
    };
  };
}
