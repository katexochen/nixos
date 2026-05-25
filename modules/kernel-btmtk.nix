{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPatches = lib.mkIf (config.my.role == "client") [
    {
      name = "btmtk";
      patch = pkgs.fetchurl {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/drivers/bluetooth/btmtk.c?id=e3ac0d9f1a205f33a43fba3b79ef74d2f604c78b";
        hash = "sha256-HjdGgDTGhxDBMX1blgtjo9Iq4udixqWGuSw8oD1zF6g=";
      };
    }
  ];
}
