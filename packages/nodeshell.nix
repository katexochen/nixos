{ writeShellApplication
, kubectl
}:

writeShellApplication {
  name = "nodeshell";
  runtimeInputs = [
    kubectl
  ];
  text = builtins.readFile ./nodeshell.sh;
}
