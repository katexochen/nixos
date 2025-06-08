{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  gitMinimal,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lan951x-led-ctl";
  version = "1.1-unstable-2024-01-22";

  src = fetchgit {
    url = "https://git.familie-radermacher.ch/linux/lan951x-led-ctl.git/";
    rev = "96bfb76dc4cf262baa13be03202fd2813494b41b";
    hash = "sha256-Z6CKox7G7WT8SLpZUhTb0urHPnFoxiyzX6VvjINHpsc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_INSTALL_PREFIX /usr)' \
                     'set(CMAKE_INSTALL_PREFIX ${builtins.placeholder "out"})'
    substituteInPlace cmake/gitversion.cmake \
      --replace-fail '#define VERSION \"''${GIT_TAG}.r''${GIT_COMMITS}.g''${GIT_COMMIT_SHORT}''${GIT_DIFF}\"' \
                     '#define VERSION \"v${finalAttrs.version}\"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gitMinimal
  ];

  buildInputs = [
    libusb1
  ];

  meta = {
    homepage = "https://git.familie-radermacher.ch/linux/lan951x-led-ctl.git/";
    license = lib.licenses.gpl3;
    mainProgram = "lan951x-led-ctl";
    platforms = lib.platforms.all;
  };
})
