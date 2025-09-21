{
  description = "Multi-host NixOS configuration for sx2, msi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim = {
    #     # url = "github:nix-community/nixvim";
    #     url = "github:nix-community/nixvim/nixos-25.05";
    #     # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Common modules for all hosts
      commonModules = [
        ./modules/home-manager/common
        ./modules/home-manager/development
        ./modules/home-manager/editor
        ./modules/home-manager/terminal
      ];

      # Host-specific module configurations
      hostModules = {
        # sx2 = commonModules; # No graphics for sx2
        sx2 = commonModules ++ [
          ./modules/home-manager/media
        ];
        msi = commonModules ++ [
          ./modules/home-manager/graphics
          ./modules/home-manager/office
          ./modules/home-manager/media
        ]; # Full feature set for msi
      };

      # Helper function to create home-manager configuration
      mkHomeManager = hostName: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.takahisa = {
          imports = hostModules.${hostName};
          home.stateVersion = "25.05";
        };
      };

    in {
      nixosConfigurations = {
        # sx2: Desktop without graphics tools
        sx2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/sx2/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHomeManager "sx2")
          ];
        };

        # msi: Full-featured desktop
        msi = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/msi/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHomeManager "msi")
          ];
        };
      };

      # Standalone home-manager configurations (optional)
      homeConfigurations = {
        "takahisa@sx2" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true; 
          };
          modules = hostModules.sx2 ++ [
            { home.stateVersion = "25.05"; }
          ];
        };
        "takahisa@msi" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true; 
          };
          modules = hostModules.msi ++ [
            { home.stateVersion = "25.05"; }
          ];
        };
      };
    };
}
