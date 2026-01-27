{
  description = "Multi-host NixOS configuration for sx2, msi, wsl";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mcp-servers-nix = { url = "github:natsukium/mcp-servers-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = { url = "github:nix-community/nixvim"; inputs.nixpkgs.follows = "nixpkgs"; };
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:nix-community/plasma-manager";
    sops-nix = { url = "github:Mic92/sops-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, plasma-manager, nixos-wsl, mcp-servers-nix, llm-agents, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      plantumlLsp = pkgs.callPackage ./tools/plantuml-lsp { };

      # Common modules for all hosts
      commonModules = [
        ./modules/home-manager/cli-tools
        ./modules/home-manager/common
        ./modules/home-manager/container
        ./modules/home-manager/misc
        ./modules/home-manager/programming
        ./modules/home-manager/terminal
        ./modules/home-manager/vcs
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
          ./modules/home-manager/geospatial-wsl
          ./modules/home-manager/graphics-wsl
          ./modules/home-manager/terminal-wsl
        ];
      };

      # Helper function to create home-manager configuration
      mkHomeManager = hostName: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          pkgs = pkgs;
          llm-agents = llm-agents;
          plantumlLsp = plantumlLsp;
          mcp-servers-nix = mcp-servers-nix;
        };
        home-manager.users.takahisa = {
          imports = hostModules.${hostName} ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
            sops-nix.homeManagerModules.sops
          ];
          home.stateVersion = "25.05";
        };
      };

    in
    {
      # Formatter for `nix fmt` - uses treefmt.toml in project root
      formatter.${system} = pkgs.treefmt;

      nixosConfigurations = {
        # sx2: Desktop without graphics tools
        sx2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/sx2/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            (mkHomeManager "sx2")
          ];
        };

        # msi: Full-featured desktop
        msi = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/msi/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
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
            sops-nix.nixosModules.sops
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
            llm-agents = llm-agents;
            plantumlLsp = plantumlLsp;
            mcp-servers-nix = mcp-servers-nix;
          };
          modules = hostModules.sx2 ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
            sops-nix.homeManagerModules.sops
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
            llm-agents = llm-agents;
            plantumlLsp = plantumlLsp;
            mcp-servers-nix = mcp-servers-nix;
          };
          modules = hostModules.msi ++ [
            nixvim.homeModules.nixvim
            plasma-manager.homeModules.plasma-manager
            sops-nix.homeManagerModules.sops
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
            llm-agents = llm-agents;
            plantumlLsp = plantumlLsp;
            mcp-servers-nix = mcp-servers-nix;
          };
          modules = hostModules.wsl ++ [
            nixvim.homeModules.nixvim
            sops-nix.homeManagerModules.sops
            {
              home.stateVersion = "25.05";
            }
          ];
        };
      };
    };
}
