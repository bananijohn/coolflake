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
	  pkgs.sketchybar
	  pkgs.sketchybar-app-font
	];

	homebrew = {
	  enable = true;
	  # Syntax: "thing"
	  brews = [
	  ];
	  casks = [
	  ];
	  taps = [
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
	dock.autohide-time-modifier = 0.3;
	dock.autohide-delay = 0.05;
	WindowManager.EnableTopTilingByEdgeDrag = true;
	finder._FXShowPosixPathInTitle = true;
	finder.QuitMenuItem = true;
	finder.ShowStatusBar = true;
      };
      
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      # Yabai config ig lmao

      services.yabai = {
        enable = true;
	enableScriptingAddition = true;
	config = {
	  window_placement = "second_child";
	  top_padding = 5;
	  bottom_padding = 5;
	  left_padding = 5;
	  right_padding = 5;
	  window_gap = 5;
	  auto_balance = "off";
	  split_ratio = 5;
	  layout = "bsp";
	  mouse_modifier = "command";
	  mouse_action1 = "move";
	  mouse_action2 = "resize";
	  window_shadow = "float";
	  window_opacity = "on";
	  active_window_opacity = "0.9";
	  normal_window_opacity = "0.7";
        };
      };

      # skhd config lol

      services.skhd = {
        enable = true;
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
    # $ darwin-rebuild build --flake .#coolflake
    darwinConfigurations."coolflake" = nix-darwin.lib.darwinSystem {
      modules = [
	configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    # User who owns homebrew:
	    user = "Ian";
	  };
	}
      ];
    };
  };
}
