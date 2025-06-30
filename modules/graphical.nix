{ pkgs, ... }:
{
  hardware.graphics.enable = true;

  boot = {
    supportedFilesystems = [ "ntfs" ];
    # puts systemd init logs on tty1
    # so that tuigreet and systemd logs don't clobber each other
    kernelParams = [ "console=tty1" ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  security.pam.services = {
    swaylock.text = "auth include login";
    swaylock-plugin.text = "auth include login";
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };

  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --remember \
              --time \
              --asterisks \
              --cmd ${pkgs.sway}/bin/sway
          '';
        };
      };
    };
  };

  fonts.enableDefaultPackages = true;
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
