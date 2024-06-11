{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lens
    kubernetes
    kubernetes-helm
    fluxcd
    kustomize
    k9s
  ];
}
