{
  description = "Multi-host NixOS configuration for sx2, msi, wsl";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    mcp-servers-nix = { url = "github:natsukium/mcp-servers-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = { url = "github:nix-community/nixvim"; inputs.nixpkgs.follows = "nixpkgs"; };
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:nix-community/plasma-manager";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, plasma-manager, nixos-wsl, mcp-servers-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nodePkgs = pkgs.callPackage ./tools/node2nix { inherit pkgs; };

      # Common modules for all hosts
      commonModules = [
        ./modules/home-manager/common
        ./modules/home-manager/cli-tools
        ./modules/home-manager/misc
        ./modules/home-manager/vcs
        ./modules/home-manager/terminal
        ./modules/home-manager/programming
      ];

      # Host-specific module configurations
      hostModules = {
        # sx2 = commonModules; # No graphics for sx2
        sx2 = commonModules ++ [
          ./modules/home-manager/desktop
          ./modules/home-manager/editor
          ./modules/home-manager/media
        ];
        msi = commonModules ++ [
          ./modules/home-manager/desktop
          ./modules/home-manager/editor
          ./modules/home-manager/graphics
          ./modules/home-manager/geospatial
          ./modules/home-manager/media
          ./modules/home-manager/office
        ];
        wsl = commonModules ++ [
          ./modules/home-manager/editor-wsl
          ./modules/home-manager/terminal-wsl
        ];
      };

      # Helper function to create home-manager configuration
      mkHomeManager = hostName: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          pkgs = pkgs;
          nodePkgs = nodePkgs;
          mcp-servers-nix = mcp-servers-nix;
        };
        home-manager.users.takahisa = {
          imports = hostModules.${hostName} ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
          ];
          home.stateVersion = "25.05";
        };
      };

    in
    {
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
          extraSpecialArgs = {
            nodePkgs = nodePkgs;
            mcp-servers-nix = mcp-servers-nix;
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
          extraSpecialArgs = {
            nodePkgs = nodePkgs;
            mcp-servers-nix = mcp-servers-nix;
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
          extraSpecialArgs = {
            nodePkgs = nodePkgs;
            mcp-servers-nix = mcp-servers-nix;
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
