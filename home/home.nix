{ pkgs, ... }:
{
  # home.stateVersion = "24.05";
  home.username = "kid";
  home.homeDirectory = "/Users/kid";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [ htop neovim ];
}
