{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      shellWrapperName = "y";

      plugins = {
        smart-enter = "${pkgs.yaziPlugins.smart-enter}";
      };

      extraPackages = with pkgs; [
        ffmpeg
        poppler
        file
        jq
        fd
        ripgrep
        fzf
        mpv
        zathura
        swayimg
      ];

      settings = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
          sort_dir_first = true;
          scrolloff = 5;
          linemode = "mtime";
          ratio = [
            1
            3
            4
          ];
        };

        preview = {
          max_width = 4000;
          max_height = 4000;
        };

        opener = {
          play = [
            {
              run = ''mpv --force-window=yes "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
          pdf = [
            {
              run = ''zathura "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
          image = [
            {
              run = ''swayimg "$@" "$(dirname "$1")"'';
              orphan = true;
              for = "unix";
            }
          ];
        };

        open.prepend_rules = [
          {
            mime = "video/*";
            use = [ "play" ];
          }
          {
            mime = "application/pdf";
            use = [ "pdf" ];
          }
          {
            mime = "image/*";
            use = [ "image" ];
          }
        ];
      };

      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<Enter>";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
        ];
      };
    };
  };
}
