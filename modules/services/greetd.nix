{ pkgs, ... }: {
  # puts systemd init logs on tty1
  # so that tuigreet and systemd logs don't clobber each other
  boot.kernelParams = [
    "console=tty1"
  ];

  # TODO: unlock gnome-keyring

  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --time --asterisks --cmd ${pkgs.sway}/bin/sway";
      };
    };
  };
}
