{
  description = "Multi-host NixOS configuration for sx2, msi, wsl";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
        url = "github:nix-community/nixvim/nixos-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, plasma-manager, nixos-wsl, ... }@inputs:
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
          ./modules/home-manager/desktop
          ./modules/home-manager/media
        ];
        msi = commonModules ++ [
          ./modules/home-manager/desktop
          ./modules/home-manager/graphics
          ./modules/home-manager/media
          ./modules/home-manager/office
        ]; # Full feature set for msi
        wsl = [
          ./modules/home-manager/common
          ./modules/home-manager/development
          ./modules/home-manager/editor-wsl
          ./modules/home-manager/terminal
        ]; # Terminal-focused environment for WSL
      };

      # Helper function to create home-manager configuration
      mkHomeManager = hostName: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          pkgs = pkgs;
        };
        home-manager.users.takahisa = {
          imports = hostModules.${hostName} ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
          ];
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

        # wsl: Terminal-focused WSL environment
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHomeManager "wsl")
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
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
            {
              home.stateVersion = "25.05";
            }
          ];
        };
        "takahisa@msi" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = hostModules.msi ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
            {
              home.stateVersion = "25.05";
            }
          ];
        };
        "takahisa@wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = hostModules.wsl ++ [
            nixvim.homeModules.nixvim
            {
              home.stateVersion = "25.05";
            }
          ];
        };
      };
    };
}
