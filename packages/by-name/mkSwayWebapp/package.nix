{
  lib,
  chromium,
  stdenvNoCC,
  writeShellApplication,
  copyDesktopItems,
  makeDesktopItem,
}:

{
  # Name of the web application.
  name,
  # URL to the web application site.
  url,
  # Packages to set as both iconsPkg and desktopItemsPkg.
  fromPkg ? null,
  # Package providing icons, must have icons under share/icons/.
  iconsPkg ? fromPkg,
  # Package providing desktop items, must have either 'desktopItems' or 'desktopItem' attribute.
  desktopItemsPkg ? fromPkg,
  # Additional arguments to pass to the desktop item, if not used from desktopItemsPkg.
  desktopItemArgs ? null,
}:

assert lib.assertMsg (
  desktopItemArgs == null || desktopItemsPkg == null
) "mkSwayWebapp: set either 'desktopItemsPkg' or 'desktopItemArgs' but not both";

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit name;
  dontUnpack = true; # No src.
  # Use writeShellApplication to create a wrapper script that
  # sets up the environment and launches the web application.
  app = writeShellApplication {
    name = "tmp-webapp-builder";
    runtimeInputs = [ chromium ];
    text = ''
      swaymsg exec 'chromium --app=${url}'
    '';
  };
  buildPhase =
    # Copy the script over so we don't depend on another derivation
    # and can use lib.getExe on this package.
    ''
      runHook preBuild
      mkdir -p $out/bin
      cp ${lib.getExe finalAttrs.app} $out/bin/${name}
    ''
    # Copy the icons over if provided, dereference symlinks.
    + lib.optionalString (iconsPkg != null) ''
      mkdir -p $out/share/icons
      cp -Lr ${iconsPkg}/share/icons/* $out/share/icons/
    ''
    # Copy the desktop items over if provided, dereference symlinks.
    + lib.optionalString (desktopItemsPkg != null) ''
      mkdir -p $out/share/applications
      cp -Lr ${desktopItemsPkg}/share/applications/* $out/share/applications
    ''
    + ''
      runHook postBuild
    '';
  nativeBuildInputs = lib.optional (desktopItemsPkg == null) copyDesktopItems;
  desktopItems = lib.optional (desktopItemsPkg == null) (
    makeDesktopItem (
      {
        inherit (finalAttrs) name;
        exec = finalAttrs.name;
        startupWMClass = finalAttrs.name;
        icon = if iconsPkg != null then finalAttrs.name else null;
      }
      // desktopItemArgs
    )
  );
  meta.mainProgram = name;
})
