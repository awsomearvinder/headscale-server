{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixinate.url = "github:matthewcroughan/nixinate";
  };

  outputs = { self, nixpkgs, nixinate }: {
    apps = nixinate.nixinate.x86_64-linux self;
    nixosConfigurations.headscale = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./src/configuration.nix
        {
          _module.args.nixinate = {
            host = "192.9.250.176";
            sshUser = "root";
            buildOn = "local"; # valid args are "local" or "remote"
            substituteOnTarget = true; # if buildOn is "local" then it will substitute on the target, "-s"
            hermetic = false;
          };
        }
      ];
    };
  };
}
