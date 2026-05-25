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

      extraPackages = with pkgs; [
        ueberzugpp
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
        };

        opener = {
          play = [
            {
              run = ''mpv "$@"'';
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
              run = ''swayimg "$@"'';
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
    };
  };
}
