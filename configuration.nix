{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    susagi = {
      isNormalUser = true;
      initialPassword = "changeme";
      openssh.authorizedKeys.keyFiles =
        [ /home/susagi/.config/nixos/pubkeys/tp_dev.pub ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ tree vim ];
    };

    clinton = {
      isNormalUser = true;
      initialPassword = "changeme";
      openssh.authorizedKeys.keyFiles =
        [ /home/clinton/.config/nixos/pubkeys/clinton.pub ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ tree ];
    };
  };
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [ git nixfmt-classic btop ethtool ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 30715 ];
openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
};
  };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; ### TODO: this is supposed to be 24.11 BUT needs further investigation it seems
}
