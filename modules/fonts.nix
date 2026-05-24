{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.my.role == "client") {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        font-awesome
        google-fonts
        dejavu_fonts
        noto-fonts-color-emoji
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        source-code-pro
        helvetica-neue-lt-std
        ubuntu-classic
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [
            "FiraCode Nerd Font Mono"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "DejaVu Sans"
            "FiraCode Nerd Font"
          ];
          serif = [ "DejaVu Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
