;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Theme and display
(setq doom-theme 'solverforge-hackerman)
(setq display-line-numbers-type t)

;; Font configuration - requires Fira Code to be installed for ligatures
(setq doom-font (font-spec :family "Fira Code" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))

;; Org directory (must be set before org loads)
(setq org-directory "~/org/")

;; Load modular configurations
(load! "+navigation")
(load! "+lsp")
(load! "+claude")
;; +copilot.el is intentionally preserved but not loaded.
