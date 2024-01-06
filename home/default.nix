{ pkgs, ... }: {
  imports = [
    ./shell
    ./sway
    ./desktop

    ./git.nix
    ./k9s.nix
  ];

  home.packages = with pkgs; [
    mpv
    pavucontrol
    texlive.combined.scheme-full

    # Nix
    cachix
    deadnix
    nix-index
    nix-init
    nix-output-monitor
    nix-tree
    nix-update
    nixpkgs-fmt
    nixpkgs-hammering
    nixpkgs-review
    nurl
    statix

    # Development
    actionlint
    cargo
    cosign
    crane
    dive
    docker
    gcc
    gh
    git-absorb
    gnumake
    go
    gopls
    gotools
    rust-analyzer
    rustc
    shellcheck
    skopeo

    # Cloud
    awscli2
    azure-cli
    azure-storage-azcopy
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    kubectl
    openstackclient
    packer
    terraform

    # CLI
    bat
    btop
    curl
    diskonaut
    eza
    fd
    file
    jq
    magic-wormhole-rs
    ncdu
    ripgrep
    seashells
    tmux
    unzip
    wget
    yq-go
    zathura

    # Fonts
    font-awesome
    dejavu_fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    source-code-pro
    helvetica-neue-lt-std
    ubuntu_font_family
  ];
}
