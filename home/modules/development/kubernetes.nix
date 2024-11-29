{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    lens
    kubernetes
    kubernetes-helm
    kustomize
    k9s
  ] ++ (with pkgs-unstable; [
    fluxcd
    cilium-cli
  ]);
}
