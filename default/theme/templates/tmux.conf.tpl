# SolverForge Linux Tmux Configuration
# Hackerman theme with OSC passthrough for proper terminal color inheritance

# Enable OSC passthrough - critical for OpenCode and other apps to inherit Kitty colors
set -g allow-passthrough on

# Enable true color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Hackerman theme colors
# Status bar
set -g status-style "bg={{ background }},fg={{ foreground }}"

# Window status
set -g window-status-style "bg={{ background }},fg={{ color8 }}"
set -g window-status-current-style "bg={{ color4 }},fg={{ background }}"
set -g window-status-activity-style "bg={{ color1 }},fg={{ background }}"
set -g window-status-bell-style "bg={{ color3 }},fg={{ background }}"

# Pane borders
set -g pane-border-style "fg={{ color8 }}"
set -g pane-active-border-style "fg={{ accent }}"

# Message style
set -g message-style "bg={{ color4 }},fg={{ background }}"
set -g message-command-style "bg={{ color4 }},fg={{ background }}"

# Clock
set -g clock-mode-colour "{{ accent }}"

# Copy mode highlighting
set -g mode-style "bg={{ selection_background }},fg={{ selection_foreground }}"

# Status bar configuration
set -g status-left "#[bg={{ accent }},fg={{ background }}] #S #[bg={{ background }},fg={{ accent }}]"
set -g status-right "#[fg={{ accent }}]#[bg={{ accent }},fg={{ background }}] %H:%M "
set -g status-left-length 50
set -g status-right-length 50

# Window numbering
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on

# Mouse support
set -g mouse on

# Longer scrollback
set -g history-limit 10000

# No delay for escape key
set -sg escape-time 0

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity off
