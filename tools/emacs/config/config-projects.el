;;; config-projects.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Project related configuration.
;;; This is mainly using projectile now, but built-in projects module seems promising for long-term.
;;; Note: this file is autogenerated from an org-mode file.
;;; Code:

(use-package projectile
  :commands
  (projectile-ack
   projectile-ag
   projectile-compile-project
   projectile-configure-project
   projectile-package-project
   projectile-install-project
   projectile-test-project
   projectile-run-project
   projectile-dired
   projectile-find-dir
   projectile-find-file
   projectile-find-file-dwim
   projectile-find-file-in-directory
   projectile-find-tag
   projectile-test-project
   projectile-grep
   projectile-invalidate-cache
   projectile-kill-buffers
   projectile-multi-occur
   projectile-project-p
   projectile-project-root
   projectile-recentf
   projectile-regenerate-tags
   projectile-replace
   projectile-replace-regexp
   projectile-run-async-shell-command-in-root
   projectile-run-shell-command-in-root
   projectile-switch-project
   projectile-switch-to-buffer
   projectile-vc
   projectile-commander)
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (setq-default projectile-completion-system 'default)
  (setq-default projectile-switch-project-action #'projectile-commander
                projectile-create-missing-test-files t)
  (setq-default compilation-buffer-name-function (lambda (mode) (concat "*" (downcase mode) ": " (projectile-project-name) "*")))
  (setq-default projectile-track-known-projects-automatically nil)
  (run-with-idle-timer 10 nil #'projectile-cleanup-known-projects)
  (def-projectile-commander-method ?s
    "Open a *shell* buffer for the project"
    (projectile-run-eshell nil))
  (def-projectile-commander-method ?c
    "Run `compile' in the project"
    (projectile-compile-project nil))
  
  (projectile-mode))

(provide 'config-projects)
;;; config-projects.el ends here
