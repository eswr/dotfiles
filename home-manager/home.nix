{ config, pkgs, ... }:

{
  home.username = "eswr";
  home.homeDirectory = "/home/eswr";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    jq
    git
  ];
  programs.home-manager.enable = true;
}
