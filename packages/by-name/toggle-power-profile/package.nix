{ writeShellApplication, power-profiles-daemon }:

writeShellApplication {
  name = "toggle-power-profile";
  runtimeInputs = [ power-profiles-daemon ];
  text = ./toggle-power-profile.sh;
}
