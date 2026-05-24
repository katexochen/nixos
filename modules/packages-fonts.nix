{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.home.packages = with pkgs; [
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
  };
}
