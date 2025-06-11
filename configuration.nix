{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ./common.nix
  ];
  environment.shellAliases = {
    ll = "ls -lAh";
    gco = "git checkout";
    gs = "git status";
    gpl = "git pull";
    gp = "git push";
    gf = "git fetch --all";
    ga = "git add";
    v = "vim";
    go2cfgdir = "cd ~/.config/nixos";
  };

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/susagi/.config/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  programs.ssh.startAgent = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    interfaces.enp1s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
    hostName = "futro"; # Define your hostname.
    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.
    firewall.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [ git nixfmt-classic btop ethtool ];

  # List services that you want to enable:

  # The services doesn't actually work atm, define an additional service see https://github.com/NixOS/nixpkgs/issues/91352
  systemd.services.wakeonlan = {
    description = "Reenable wake on lan every boot";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      RemainAfterExit = "true";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp1s0 wol g";
    };
    wantedBy = [ "default.target" ];
  };

  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion =
    "25.11"; # ## TODO: this is supposed to be 24.11 BUT needs further investigation it seems
}
