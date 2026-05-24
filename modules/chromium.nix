{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.chromium = {
      enable = true;
      package = pkgs.chromium.override {
        enableWideVine = true;
      };
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-features=WebRTCPipeWireCapturer"
      ];
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
        { id = "logpjaacgmcbpdkdchjiaagddngobkck"; } # shortkeys
      ];
    };
  };
}
