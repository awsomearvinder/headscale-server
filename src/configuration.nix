{ config, pkgs, ... }: 
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNC3e1bJjjG7KHxjflwGLme5nG7/3DhNcpknkqvumOFoJz5tJepAWZTpzijmZOL8E9X8VJaPafj759QLhFLJsnlEjhiZjOMOvKBdWSnMc/7jLPWuvySa2ChU1bwXONNBDfKKy/qFIh7ZU2kePQ5AEGFHBCNiLDB+bdprXfWFnrKZAl8boZHskh+3soaYln6iaZpBqu2OJNbni/MRt4IT265U84f07txqfzzA1anoB0BHou7w7OosuTmI3GnL+cOxOvIsmczEFugNdl8bbXkL3C+14fZpfzjz3IiWOFds7DkCeVh+/QIvzdmmuWz0tnXINE49u34dL+OLKXMGdcznpIpcX83bgt0q6t2gTeM5ovHxjF3TFQSXC2Zpy9G5HHvbJnAp1eLRv7c4l755Bo8L6QBRPQK1wqGNIKgYL2IJSagQZ0H2J8g+hBAm1VuEpVQ6EWWSl9UMEv2nLy+zA52Q8LXsOZK3xRa4V16j/b6OOMLj3TfEtSPHG4VkyUxE0s2/U= bender@desktop"
  ];
  # Name your host machine
  networking.hostName = "headscale"; 

  # Set your time zone.
  time.timeZone = "US/Chicago";

  # Install some packages
  environment.systemPackages = with pkgs; [
    headscale
  ]; 

  services.headscale.enable = true;
  services.headscale.address = "0.0.0.0";
  services.headscale.serverUrl = "https://headscale.arvinderd.com:443";
  services.headscale.tls.letsencrypt.hostname = "headscale.arvinderd.com";
  services.headscale.port = 443;
  services.headscale.dns.baseDomain = "headscale.arvinderd.com";
  services.headscale.aclPolicyFile = builtins.toFile "acl.yaml" (builtins.toJSON {
    groups = {
      "groups:admin" = ["arvinder"];
    };
    acls = [
      {action = "accept"; src = ["arvinder"]; dst = ["arvinder:*"];}
    ];
  });

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
 
  # Enable the OpenSSH daemon
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  system.stateVersion = "22.05";
}
