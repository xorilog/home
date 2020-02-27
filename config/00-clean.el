(use-package recentf
  :custom
  (recentf-max-menu-items 15)
  (recentf-max-saved-items 200)
  (recentf-auto-cleanup 360)
  (recentf-show-file-shortcuts-flag nil)
  :config
  (recentf-mode 1)
  (add-to-list 'recentf-exclude "^/\\(?:ssh\\|su\\|sudo\\)?:")
  ;; Magic advice to rename entries in recentf when moving files in
  ;; dired.
  (defun rjs/recentf-rename-notify (oldname newname &rest args)
    (if (file-directory-p newname)
        (rjs/recentf-rename-directory oldname newname)
      (rjs/recentf-rename-file oldname newname)))

  (defun rjs/recentf-rename-file (oldname newname)
    (setq recentf-list
          (mapcar (lambda (name)
                    (if (string-equal name oldname)
                        newname
                      oldname))
                  recentf-list))
    recentf-cleanup)

  (defun rjs/recentf-rename-directory (oldname newname)
    ;; oldname, newname and all entries of recentf-list should already
    ;; be absolute and normalised so I think this can just test whether
    ;; oldname is a prefix of the element.
    (setq recentf-list
          (mapcar (lambda (name)
                    (if (string-prefix-p oldname name)
                        (concat newname (substring name (length oldname)))
                      name))
                  recentf-list))
    recentf-cleanup)

  (advice-add 'dired-rename-file :after #'rjs/recentf-rename-notify)

  (defun contrib/recentf-add-dired-directory ()
    "Include Dired buffers in the list.  Particularly useful when
combined with a completion framework's ability to display virtual
buffers."
    (when (and (stringp dired-directory)
               (equal "" (file-name-nondirectory dired-directory)))
      (recentf-add-file dired-directory))))

(use-package no-littering               ; Keep .emacs.d clean
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)

  ;; Move this in its own thing
  (setq
   create-lockfiles nil
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

  (setq
   backup-directory-alist
   `((".*" . ,(no-littering-expand-var-file-name "backup/")))
   auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))
