{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-features=WebRTCPipeWireCapturer"
    ];
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "logpjaacgmcbpdkdchjiaagddngobkck"; } # shortkeys
    ];
  };
}
