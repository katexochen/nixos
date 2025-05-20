{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override {
      # Proprietary blob for DRM to enable Netflix/Spotify and co.
      enableWideVine = true;
    };
    commandLineArgs = [
      # Flags for Wayland & PipeWire support
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
}
