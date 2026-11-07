{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    package = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform}.tmux;
    terminal = "tmux-256color";
    escapeTime = 10;
    clock24 = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
      vim-tmux-navigator
      vim-tmux-focus-events
      open
      tmux-fzf
      fingers
      gruvbox
    ];
    baseIndex = 1;
    newSession = true;
    extraConfigBeforePlugins = ''
      # Set custom prefix & send it to current pane when pressed twice (Ctrl-b still works)
      set -g prefix '`'
      set -g prefix2 C-b
      bind '`' send-prefix

      # Some extra settings not available through nix
      set -g mouse on
      set -g renumber-windows on
      set -g display-time 2000
      set -s focus-events on
      set -g set-titles on
      set -g set-titles-string "#S / #W"
      setw -g monitor-activity on
      set -s set-clipboard on
      setw -g copy-mode-line-numbers absolute
      setw -g pane-scrollbars auto-hide

      # Extra vim keybindings
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel

      # Pane & window bindings (defaults are still overridden such that they open in the current directory
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      # New windows open in the current directory too
      bind c new-window -c "#{pane_current_path}"
      # Prefix + h/j/k/l moves between panes like Vim
      # (l replaces last-window; Prefix + ; still goes to the last pane)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # Prefix + H/J/K/L resizes the pane by 5 cells; hold the letter to repeat
      # (L replaces switch-client -l)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
    '';
    extraConfig = ''
      set -g @tmux-gruvbox 'dark'
      set -g @continuum-restore 'on'
    '';
  };
}
