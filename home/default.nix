{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./shell
    ./sway
    ./desktop

    ./git.nix
    ./k9s.nix
  ];

  home.packages = with pkgs; [
    mpv
    nixpkgs-fmt
    pavucontrol
    texlive.combined.scheme-full

    # Development
    bazel-buildtools
    crane
    dive
    docker
    gcc
    gh
    gnumake
    go
    gopls
    gotools
    shellcheck

    # Cloud
    awscli2
    azure-cli
    azure-storage-azcopy
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    kubectl
    openstackclient
    terraform

    # CLI
    bat
    curl
    exa
    fd
    file
    htop
    jq
    ripgrep
    unzip
    wget
    yq-go
    zathura

    # Fonts
    font-awesome
    dejavu_fonts
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
    source-code-pro
    helvetica-neue-lt-std
    ubuntu_font_family

    droidcam
    zoom-us
  ];
}
