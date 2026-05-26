{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.my.role == "client") {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        font-awesome
        google-fonts
        dejavu_fonts
        noto-fonts-color-emoji
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        helvetica-neue-lt-std
        ubuntu-classic
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [
            "JetBrains Mono"
            "JetBrainsMono Nerd Font"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "DejaVu Sans"
            "JetBrainsMono Nerd Font"
          ];
          serif = [ "DejaVu Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
