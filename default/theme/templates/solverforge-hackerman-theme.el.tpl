;;; solverforge-hackerman-theme.el --- Generated SolverForge theme -*- lexical-binding: t; no-byte-compile: t; -*-

;; Generated from default/theme/colors.toml by solverforge-theme-apply.
;; Edit the palette or this template, not the generated file.

;;; Code:

(deftheme solverforge-hackerman
  "SolverForge's Hackerman palette for Doom Emacs.")

(let ((accent "{{ accent }}")
      (background "{{ background }}")
      (cursor "{{ cursor }}")
      (foreground "{{ foreground }}")
      (selection-background "{{ selection_background }}")
      (selection-foreground "{{ selection_foreground }}")
      (subtle "{{ color8 }}")
      (green "{{ color2 }}")
      (bright-green "{{ color9 }}")
      (aqua "{{ color6 }}")
      (cyan "{{ color14 }}")
      (blue "{{ color12 }}")
      (bright "{{ color15 }}"))
  (custom-theme-set-faces
   'solverforge-hackerman
   `(default ((t (:background ,background :foreground ,foreground))))
   `(cursor ((t (:background ,cursor))))
   `(fringe ((t (:background ,background :foreground ,subtle))))
   `(region ((t (:background ,selection-background :foreground ,selection-foreground))))
   `(highlight ((t (:background ,subtle :foreground ,bright))))
   `(hl-line ((t (:background ,background :extend t))))
   `(minibuffer-prompt ((t (:foreground ,accent :weight bold))))
   `(mode-line ((t (:background ,subtle :foreground ,bright :box nil))))
   `(mode-line-inactive ((t (:background ,background :foreground ,subtle :box nil))))
   `(line-number ((t (:background ,background :foreground ,subtle))))
   `(line-number-current-line ((t (:background ,background :foreground ,accent :weight bold))))
   `(vertical-border ((t (:foreground ,subtle))))
   `(link ((t (:foreground ,aqua :underline t))))
   `(match ((t (:background ,selection-background :foreground ,selection-foreground :weight bold))))
   `(success ((t (:foreground ,green :weight bold))))
   `(warning ((t (:foreground ,bright-green :weight bold))))
   `(error ((t (:foreground ,accent :weight bold))))
   `(font-lock-builtin-face ((t (:foreground ,aqua))))
   `(font-lock-comment-face ((t (:foreground ,subtle :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,subtle :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,cyan))))
   `(font-lock-function-name-face ((t (:foreground ,green))))
   `(font-lock-keyword-face ((t (:foreground ,accent :weight bold))))
   `(font-lock-string-face ((t (:foreground ,bright-green))))
   `(font-lock-type-face ((t (:foreground ,blue))))
   `(font-lock-variable-name-face ((t (:foreground ,foreground))))
   `(font-lock-warning-face ((t (:foreground ,accent :weight bold))))))

;;;###autoload
(when (and load-file-name (boundp 'custom-theme-load-path))
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'solverforge-hackerman)

;;; solverforge-hackerman-theme.el ends here
