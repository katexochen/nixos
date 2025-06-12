{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "regovis";
  version = "0-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "burgerdev";
    repo = "regovis";
    rev = "c1ee5833c5675921375db967a7041abaa95be156";
    hash = "sha256-foU1WRLRIZsrDPUvFVHTnaZu/g5kl//oqVAUyos6+rU=";
  };

  vendorHash = "sha256-ZAozOSkP6P/Q1GES4La/JDyU1m9Ce6dyrUl8vf73Xaw=";
  proxyVendor = true;

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  meta = {
    description = "tool for visualizing complex Rego modules";
    homepage = "https://github.com/burgerdev/regovis";
    license = lib.licenses.isc;
    mainProgram = "regovis";
  };
}
