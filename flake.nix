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
          ./modules/home-manager/misc
          ./modules/home-manager/media
          ./modules/home-manager/office
        ];
        wsl = commonModules ++ [
          ./modules/home-manager/editor-wsl
          ./modules/home-manager/geospatial-wsl
          ./modules/home-manager/graphics-wsl
          ./modules/home-manager/misc-wsl
          ./modules/home-manager/terminal-wsl
        ];
      };

      lib = nixpkgs.lib;

      # Common extraSpecialArgs for home-manager
      hmExtraSpecialArgs = {
        inherit llm-agents plantumlLsp mcp-servers-nix;
      };

      # Common home-manager modules
      hmCommonModules = hostName:
        hostModules.${hostName} ++ [
          nixvim.homeModules.nixvim
          sops-nix.homeManagerModules.sops
        ] ++ lib.optionals (hostName != "wsl") [
          plasma-manager.homeModules.plasma-manager
        ] ++ [{
          home.stateVersion = "25.05";
        }];

      # Helper function to create NixOS home-manager integration
      mkHomeManager = hostName: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = hmExtraSpecialArgs;
        home-manager.users.takahisa = {
          imports = hmCommonModules hostName;
        };
      };

      # Helper function to create standalone home-manager configuration
      mkHomeManagerConfiguration = hostName: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = hmExtraSpecialArgs;
        modules = hmCommonModules hostName;
      };

    in
    {
      # Formatter for `nix fmt` - uses treefmt.toml in project root
      formatter.${system} = pkgs.treefmt;

      nixosConfigurations = {
        # sx2: Desktop without graphics tools
        sx2 = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./hosts/sx2/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            (mkHomeManager "sx2")
          ];
        };

        # msi: Full-featured desktop
        msi = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./hosts/msi/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            (mkHomeManager "msi")
          ];
        };

        # wsl: Terminal-focused WSL environment
        wsl = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            (mkHomeManager "wsl")
          ];
        };
      };

      # Standalone home-manager configurations
      homeConfigurations = {
        "takahisa@sx2" = mkHomeManagerConfiguration "sx2";
        "takahisa@msi" = mkHomeManagerConfiguration "msi";
        "takahisa@wsl" = mkHomeManagerConfiguration "wsl";
      };
    };
}
