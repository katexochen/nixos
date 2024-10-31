{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  libxcrypt,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
  cairo,
  gdk-pixbuf,
  pam,
  nix-update-script,
}:

stdenv.mkDerivation (final: {
  version = "1.8.0";
  src = fetchFromGitHub {
    owner = "mstoeckl";
    repo = "swaylock-plugin";
    rev = "refs/tags/v${final.version}";
    hash = "sha256-Kd6Gqs+YnQu3qKfEeqW5CG38bU2gH2hqjoFEojWa8a4=";
  };
  pname = "swaylock-plugin";

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    cairo
    libxcrypt
    gdk-pixbuf
    libxkbcommon
    pam
    wayland
    wayland-protocols
  ];

  # Pleasing GCC.
  # TOREMOVE when https://github.com/mstoeckl/swaylock-plugin/pull/14
  # gets merged
  env.NIX_CFLAGS_COMPILE = "-Wno-maybe-uninitialized";

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screen locker for Wayland, forked from swaylock";
    longDescription = ''
      swaylock-pulgins is a fork of swaylock, a screen locking utility for Wayland compositors.
      On top of the usual swaylock features, it allow you to use a
      subcommand to generate the lockscreen background.
      Important note: You need to set "security.pam.services.swaylock-plugin = {};" manually.
    '';
    inherit (final.src.meta) homepage;
    mainProgram = "swaylock-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ picnoir ];
  };
})
