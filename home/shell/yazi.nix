{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      ueberzugpp # image preview in Alacritty
      ffmpeg # video thumbnails in preview pane
      poppler # pdftoppm for PDF preview pane
      file
      jq
      fd
      ripgrep
      fzf

      mpv # external video player
      zathura # external PDF viewer
      swayimg # external image viewer
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
}
