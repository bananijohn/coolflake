{
  description = "Not an example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixvim, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # Installed packages. to search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.neovim-unwrapped
	  pkgs.skhd
	  pkgs.jankyborders
#	  pkgs.aerospace
	  pkgs.bat
	  pkgs.wget
	  pkgs.kitty
	  pkgs.fzf
	  pkgs.cava
	  pkgs.mkalias
	  pkgs.cmatrix
	  pkgs.yazi
	  pkgs.gh
	  pkgs.git
	  pkgs.home-manager
	  pkgs.vesktop
	  pkgs.kitty-img
	  pkgs.kitty-themes
	  pkgs.yabai
	  pkgs.fastfetch
	  pkgs.sketchybar
	  pkgs.sketchybar-app-font
	  pkgs.jq
	  pkgs.starship
	  pkgs.stow
	];


	homebrew = {
	  enable = true;
	  # Syntax: "thing"
	  brews = [
	  ];
	  casks = [
	    "typeface"
	    "font-symbols-only-nerd-font"
	    "font-proggy-clean-tt-nerd-font"
	    "background-music"
	    "desktoppr"
	    "raycast"
	    "zen-browser"
	    "font-fira-code-nerd-font"
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
	dock.autohide-time-modifier = 0.1;
	dock.autohide-delay = 0.05;
	dock.minimize-to-application = true;
	dock.show-recents = false;
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
	  focus_follows_mouse = "autofocus";
	  mouse_follows_focus = "on";
	  top_padding = 10;
	  bottom_padding = 10;
	  left_padding = 10;
	  right_padding = 10;
	  window_gap = 10;
	  auto_balance = "on";
	  split_ratio = 5;
	  layout = "bsp";
	  mouse_modifier = "ctrl";
	  mouse_action1 = "move";
	  mouse_action2 = "resize";
	  window_shadow = "float";
	  window_opacity = "on";
	  active_window_opacity = "0.95";
	  normal_window_opacity = "0.9";
        };
	extraConfig = "sudo yabai --load-sa && yabai -m config external_bar all:37:0";
      };

      # skhd config lol

      services.skhd = {
        enable = true;
    };
      
      # Zsh config :D

      programs.zsh = {
	  enableFastSyntaxHighlighting = true;
	};

      # Sketchybar config

      services.sketchybar = {
        enable = true;
    };
      
      # Jankyborders :3
      services.jankyborders = {
        enable = true;
	active_color = "gradient(top_right=0xff85c1dc,bottom_left=0xff8caaee)";
	inactive_color = "0xff949cbb";
	width = 5.0;
	order = "below";
	blacklist = [
	  "Raycast"
	  ];
	style = "round";
	hidpi = true;
    };

      # Necessary for using flakes on this system.
      nix.settings = { 
        experimental-features = "nix-command flakes";
	trusted-users = [
	  "root"
	  "@admin"
	];
    };

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
	nixvim.nixDarwinModules.nixvim
	{
	  programs.nixvim = {
	    enable = true;
	    plugins.lualine.enable = true;
	    colorschemes.catppuccin = {
	      enable = true;
	      autoLoad = true;
	      settings = {
	        flavour = "frappe";
		integrations = {
		  lualine.nvim = true;
		};
	    };
	  };
        };
      }
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    # User who owns homebrew:
	    user = "ban";
	  };
	}
      ];
    };
  };
}
