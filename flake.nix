{
  description = "NixOS Laptop Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs, home-manager, awww, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.zaina = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [ 
	  ./configuration.nix
	  home-manager.nixosModules.home-manager 
	  {
	    home-manager = {
        useGlobalPkgs = true;
	      useUserPackages = true;

        extraSpecialArgs = {
          inherit awww;
        };

	      users.zaina = import ./home.nix;
	      backupFileExtension = "backup";
	    };
	  }
	];
      };
    };
}
