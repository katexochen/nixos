{
  oras,
  runCommand,
}:

{
  name ? "",
  image,
  sha256,
}:

runCommand "${name}"
  {
    nativeBuildInputs = [ oras ];
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = sha256;
    preferLocalBuild = true;
  }
  ''
    oras blob fetch --output $out "${image}@sha256:${sha256}"
  ''

# ensure the image exist, then push blob and use digest from that:
# oras push <image> <file>
# oras blob push <image> <file>
