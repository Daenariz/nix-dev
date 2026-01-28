# nix-dev: Quickstart for NixOS & Flakes

Welcome to our shared NixOS repository! This setup is designed to help you get started with NixOS and Nix Flakes. Flakes ensure that our system configuration is reproducible and that everyone uses the same versions of software.

## Project Overview

- `flake.nix`: The "brain" of the setup. It defines where we get our software (nixpkgs) and which hosts (like 'futro') exist.
- `configuration.nix`: The main configuration file. This is where you enable services or change system-wide settings.
- `users.nix`: This is where we manage our user accounts and their associated SSH keys.
- `common.nix`: Shared settings like timezones, locales, and SSH security tweaks.

## How to use this for the first time

1. Clone this repo to your config directory:
   ```
   cd ~/.config
   git clone <repo-url> nixos
   ```
2. To apply any changes you made to the files:
   `sudo nixos-rebuild switch --flake .#futro`

## How to add yourself or change things

### Adding a Package
If you want to add a tool (e.g., 'htop'), open 'configuration.nix', find 'environment.systemPackages', and add the package name to the list.

### Managing Users
User accounts are defined in 'users.nix'.
- To add an SSH key, place the .pub file in the 'pubkeys/' folder.
- Link it in 'users.nix' by adding the path to 'openssh.authorizedKeys.keyFiles'.

### Updating Software
To update the entire system to the latest versions from the 'nixos-unstable' branch:
1. `nix flake update`
2. `sudo nixos-rebuild switch --flake .#futro`

## Useful Aliases
We have pre-configured some shortcuts for you (see configuration.nix):
- v: Open Vim
- gs / gp / gpl: Git shortcuts (status, push, pull)
- go2cfgdir: Quickly jump to this configuration folder

## Note on StateVersion
We are currently testing '25.11'. If you run into issues with systemd services or hardware compat, check the 'configuration.nix' comments regarding stateVersion.
