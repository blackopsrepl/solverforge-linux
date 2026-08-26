;;; +claude.el --- Claude Code integration -*- lexical-binding: t; -*-

(use-package! claude-code
  :config
  (setq claude-code-terminal-backend 'vterm)
  (setq claude-code-window-side 'right)
  :bind-keymap ("C-c c" . claude-code-command-map))

;; Force Claude buffer to open on the right side
(set-popup-rule! "^\\*claude-code\\*" :side 'right :size 0.4 :select t)
