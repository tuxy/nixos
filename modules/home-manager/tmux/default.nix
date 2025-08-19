{...}: {
  programs.tmux = {
    enable = true;
    extraConfig = ''

      # reloading bind
      bind r source-file ~/.tmux.conf

      # Change prefix to Ctrl-a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Slightly more sane pane commands

      bind h split-window -h
      bind v split-window -v
      unbind '"'
      unbind %

      # Pane movement
      # Both arrow keys & hjkl for colemak
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D

      set -s escape-time 10
    '';
  };
}
