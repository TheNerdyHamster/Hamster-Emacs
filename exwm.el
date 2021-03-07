(defun tnh/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(use-package exwm
  :config
  (setq exwm-workspace-number 5)

  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j ;; Buffer list
          ?\C-\ )) ;; C+[SPC]

  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  (setq exwm-input-global-keys
        `(
          ([?\s-r] . exwm-reset)

          ([?\s-h] . windowmove-left)
          ([?\s-l] . windowmove-right)
          ([?\s-k] . windowmove-up)
          ([?\s-j] . windowmove-down)

          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ([?\s-w] . exwm-workspace-switch)

          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
  (exwm-enable))