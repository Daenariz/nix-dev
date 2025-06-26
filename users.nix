{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    susagi = {
      isNormalUser = true;
      initialPassword = "changeme";
      openssh.authorizedKeys.keyFiles = [ ./pubkeys/tp_dev.pub ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ tree vim ];
    };

    clinton = {
      isNormalUser = true;
      initialPassword = "changeme";
      openssh.authorizedKeys.keyFiles = [ ./pubkeys/clinton.pub ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ tree ];
    };

    mxdb = {
      isNormalUser = true;
      initialPassword = "changeme";
      openssh.authorizedKeys.keyFiles = [ ./pubkeys/mxdb.pub ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ tree ];
    };
  };
}
