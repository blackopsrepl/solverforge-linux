;;; +navigation.el --- Treemacs and Harpoon configuration -*- lexical-binding: t; -*-

;; TREEMACS - Clean, consistent navigation
(after! treemacs
  (setq treemacs-position 'right
        treemacs-width 35
        treemacs-follow-mode t            ; auto-highlight current file
        treemacs-project-follow-mode t)   ; auto-expand to current project

  ;; E expands all directories recursively
  (define-key treemacs-mode-map (kbd "E") #'+private/treemacs-expand-all))

;; RET opens file and switches to it (must use evil-treemacs-state-map, not treemacs-mode-map)
(after! treemacs-evil
  (define-key evil-treemacs-state-map [return] #'treemacs-visit-node-no-split))

(defun +private/treemacs-expand-all ()
  "Recursively expand all directories in all projects."
  (interactive)
  (let ((count 1))
    (while (> count 0)
      (setq count 0)
      (save-excursion
        (goto-char (point-min))
        (while (not (eobp))
          (when-let ((btn (treemacs-current-button)))
            (when (memq (treemacs-button-get btn :state)
                        '(dir-node-closed root-node-closed))
              (treemacs-toggle-node)
              (cl-incf count)))
          (forward-line 1))))))

(defun +private/treemacs-toggle ()
  "Show the current project in Treemacs, or hide a visible Treemacs window."
  (interactive)
  (require 'treemacs)
  (pcase (treemacs-current-visibility)
    ('visible (delete-window (treemacs-get-local-window)))
    (_        (treemacs-add-and-display-current-project-exclusively)
              (treemacs-select-window))))

(map! :leader :n "e" #'+private/treemacs-toggle)

;; Remove Doom's default treemacs binding (we use SPC e instead)
(map! :leader "o p" nil)

;; HARPOON
(map! :leader "j j" 'harpoon-quick-menu-hydra)
(map! :n "C-s" 'harpoon-add-file)
(map! :leader "j c" 'harpoon-clear)
(map! :leader "j f" 'harpoon-toggle-file)
(map! :leader "1" 'harpoon-go-to-1)
(map! :leader "2" 'harpoon-go-to-2)
(map! :leader "3" 'harpoon-go-to-3)
(map! :leader "4" 'harpoon-go-to-4)
(map! :leader "5" 'harpoon-go-to-5)
(map! :leader "6" 'harpoon-go-to-6)
(map! :leader "7" 'harpoon-go-to-7)
(map! :leader "8" 'harpoon-go-to-8)
(map! :leader "9" 'harpoon-go-to-9)
