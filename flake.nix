{
  description = "Not an example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # Installed packages. to search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.neovim
	  pkgs.kitty
	  pkgs.mkalias
	  pkgs.git
	  pkgs.home-manager
	  pkgs.oh-my-zsh
	  pkgs.vesktop
	  pkgs.kitty-img
	  pkgs.kitty-themes
	  pkgs.yabai
	  pkgs.skhd
	  pkgs.fastfetch
	];

	homebrew = {
	  enable = true;
	  # Syntax: "thing"
	  brews = [
	  ];
	  casks = [
	  ];
	  # Deletes unused packages for maximum declaration
	  onActivation.cleanup = "zap";
	  onActivation.autoUpdate = true;
	  onActivation.upgrade = true;
	};

	system.activationScripts.applications.text = let
  env = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = "/Applications";
  };
in
  pkgs.lib.mkForce ''
  # Set up applications.
  echo "setting up /Applications..." >&2
  rm -rf /Applications/Nix\ Apps
  mkdir -p /Applications/Nix\ Apps
  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  while read -r src; do
    app_name=$(basename "$src")
    echo "copying $src" >&2
    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
      '';

      system.defaults = {
        dock.autohide = true;
	WindowManager.EnableTopTilingByEdgeDrag = true;
	finder._FXShowPosixPathInTitle = true;
	finder.QuitMenuItem = true;
	finder.ShowStatusBar = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Backwards compatibility (read changelog b4 changin)
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ~/.config/nix#coolflake
    darwinConfigurations."coolflake" = nix-darwin.lib.darwinSystem {
      modules [
        configuration
	nix-homebrew.darwinModules.nix-homebrew {
	  nix-homebrew = {
	    enable = true;
	    # User who owns homebrew:
	    user = "";
	  };
	};
      ];
    };
  };
}
