;;; +lsp.el --- Eglot/LSP configuration -*- lexical-binding: t; -*-

(after! eglot
  ;; Rust: use rust-analyzer with clippy
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) .
                 ("rust-analyzer" :initializationOptions
                  (:check (:command "clippy")
                   :cargo (:buildScripts (:enable t))
                   :procMacro (:enable t)))))

  ;; Python: use pyright with venv-aware configuration
  (setq-default eglot-workspace-configuration
                '(:python.analysis (:autoSearchPaths t
                                    :useLibraryCodeForTypes t
                                    :diagnosticMode "openFilesOnly")))

  ;; Shutdown LSP server when last buffer is closed
  (setq eglot-autoshutdown t))

;; Auto-detect and activate virtual environment
(defun my/auto-detect-venv ()
  "Auto-detect and activate a virtual environment for the current project."
  (unless (bound-and-true-p pyvenv-virtual-env)
    (let* ((root (or (projectile-project-root)
                     (vc-root-dir)
                     default-directory))
           (venv-candidates (list
                             (expand-file-name ".venv" root)
                             (expand-file-name "venv" root)
                             (expand-file-name ".env" root)
                             (expand-file-name "env" root))))
      (cl-loop for venv in venv-candidates
               when (and (file-directory-p venv)
                         (file-exists-p (expand-file-name "bin/python" venv)))
               do (progn
                    (pyvenv-activate venv)
                    (message "Auto-activated venv: %s" venv)
                    (cl-return))))))

;; Configure pyright with virtual environment
(defun my/eglot-pyright-venv ()
  "Configure pyright to use the current virtual environment."
  (when (bound-and-true-p pyvenv-virtual-env)
    (setq-local eglot-workspace-configuration
                `(:python.analysis (:autoSearchPaths t
                                    :useLibraryCodeForTypes t
                                    :diagnosticMode "openFilesOnly"
                                    :venvPath ,(file-name-directory pyvenv-virtual-env)
                                    :venv ,(file-name-nondirectory (directory-file-name pyvenv-virtual-env)))))))

;; Restart eglot when virtual environment changes
(add-hook 'pyvenv-post-activate-hooks
          (lambda ()
            (my/eglot-pyright-venv)
            (when (eglot-managed-p)
              (eglot-reconnect (eglot-current-server)))))

;; Auto-start eglot for Rust and Python
(add-hook 'rust-mode-hook 'eglot-ensure)
;; For Python: detect venv first, then configure, then start eglot
(add-hook 'python-mode-hook #'my/auto-detect-venv -90)
(add-hook 'python-mode-hook #'my/eglot-pyright-venv -80)
(add-hook 'python-mode-hook #'eglot-ensure -70)

;; Ensure flymake shows errors inline (underlines)
(after! flymake
  (setq flymake-fringe-indicator-position 'left-fringe))
