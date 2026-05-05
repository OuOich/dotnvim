{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    wakatime-cli
  ];

  plugins.wakatime = {
    enable = true;
    autoLoad = true;
  };

  globals.wakatime_CLI = "wakatime-cli";
}
