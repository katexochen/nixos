{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      autohint = true; # no difference
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default"; # no difference
    };
  };
}
