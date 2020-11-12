(when window-system
  (blink-cursor-mode 0)                           ; Disable the cursor blinking
  (scroll-bar-mode 0)                             ; Disable the scroll bar
  (tool-bar-mode 0)                               ; Disable the tool bar
  (tooltip-mode 0))                               ; Disable the tooltips

(setq-default
 ad-redefinition-action 'accept                   ; Silence warnings for redefinition
 auto-save-list-file-prefix nil                   ; Prevent tracking for auto-saves
 cursor-in-non-selected-windows nil               ; Hide the cursor in inactive windows
 cursor-type 'bar                                 ; Prefer a bar-shaped cursor by default
 delete-by-moving-to-trash t                      ; Delete files to trash
 fill-column 80                                   ; Set width for automatic line breaks
 gc-cons-threshold (* 8 1024 1024)                ; We're not living in the 70s anymore
 read-process-output-max (* 1024 1024)            ; Increase the read output for larger files.
 help-window-select t                             ; Focus new help windows when opened
 indent-tabs-mode nil                             ; Stop using tabs to indent
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message ""                       ; Empty the initial *scratch* buffer
 mouse-yank-at-point t                            ; Yank at point rather than pointer
 recenter-positions '(5 top bottom)               ; Set re-centering positions
 scroll-conservatively most-positive-fixnum       ; Always scroll by one line
 scroll-margin 2                                  ; Add a margin when scrolling vertically
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 sentence-end-double-space nil                    ; Use a single space after dots
 show-help-function nil                           ; Disable help text on most UI elements
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; Resize windows proportionally
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width
(cd "~/")                                         ; Move to the user directory
(delete-selection-mode 1)                         ; Replace region when inserting text
(fringe-mode '(2 . 0))                            ; Initialize thinner vertical fringes
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(global-subword-mode 1)                           ; Iterate through CamelCase words
(menu-bar-mode 0)                                 ; Disable the menu bar
(mouse-avoidance-mode 'exile)                     ; Avoid collision of mouse with point
(put 'downcase-region 'disabled nil)              ; Enable downcase-region
(put 'upcase-region 'disabled nil)                ; Enable upcase-region
(set-default-coding-systems 'utf-8)               ; Default to utf-8 encoding
(column-number-mode)                              ; Toggle column number mode for mode lines.
(global-display-line-numbers-mode t)              ; Toggle line numbers within buffer

(if (eq window-system 'ns)
    (set-frame-parameter nil 'fullscreen 'maximized)
  (set-frame-parameter nil 'fullscreen 'fullboth))

(add-hook 'focus-out-hook #'garbage-collect)

(defvar nhe/waka-time-token    nil               "The Waka time API token to use.")
(defvar nhe/font-family        "Fira Code NF"    "Default font family to use")
(defvar nhe/font-size-default  100               "The font size to use for default text.")
(defvar nhe/font-size-large    1.2               "The font size to use for larger text.")
(defvar nhe/font-size-small    .8                "The font size to use for smaller text.")

(let ((config.el (expand-file-name ".config.el" user-emacs-directory)))
  (load config.el t))

(setq user-emacs-directory "~/.cache/emacs/"
      backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      url-history-file (expand-file-name "url/history" user-emacs-directory)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-emacs-directory)
      projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" user-emacs-directory))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(server-start)

(setq nhe/exwm-enabled (and (eq window-system 'x)
                           (seq-contains command-line-args "--use-exwm")))

(when nhe/exwm-enabled
  (load-file "~/.emacs.d/exwm.el"))

(use-package modus-vivendi-theme
  :config
  (load-theme 'modus-vivendi t)
  :custom
  (modus-vivendi-theme-bold-constructs nil)
  (modus-vivendi-theme-slanted-constructs t)
  (modus-vivendi-theme-syntax 'alt-syntax)
  (modus-vivendi-theme-no-mixed-fonts t)
  (modus-vivendi-theme-org-blocks 'greyscale)
  (modus-vivendi-theme-headings '((t . rainbow)))
  (modus-vivendi-theme-scale-headings t)
  :config
  (set-face-attribute 'default nil :family "FiraCode NF" :height 110))

(use-package all-the-icons
  :if (display-graphic-p)
  :commands all-the-icons-install-fonts
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(dolist (mode '(org-mode-hook
                vterm-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font nhe/font-family :height nhe/font-size-default)

(set-face-attribute 'fixed-pitch nil :font nhe/font-family :height nhe/font-size-default)

(set-face-attribute 'variable-pitch nil :font nhe/font-family :height nhe/font-size-small :weight 'regular)

(use-package ligature
  :load-path "~/.emacs.d/github/ligature"
  :config
  ;; Enable the www ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))

  ;; Enable ligatures in programming modes                                                           
  (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
  ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
  "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
  "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
  "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
  "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
  "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
  "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
  "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
  "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

  (global-ligature-mode 't))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom 
  (doom-modeline-height 15)
  (doom-themes-visual-bell-config)
  :config
  (display-battery-mode t)
  (display-time-mode t))
(use-package doom-modeline
  :demand t
  :custom
  (doom-modeline-bar-width 1)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-enable-word-count t)
  (doom-modeline-icon (display-graphic-p))
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-percent-position nil)
  (doom-modeline-vcs-max-length 28)
  :config
  (doom-modeline-def-segment nhe/buffer
    "The buffer description and major mode icon."
    (concat (doom-modeline-spc)
            (doom-modeline--buffer-name)
            (doom-modeline-spc)))
  (doom-modeline-def-segment nhe/buffer-position
    "The buffer position."
    (let* ((active (doom-modeline--active))
           (face (if active 'mode-line 'mode-line-inactive)))
      (propertize (concat (doom-modeline-spc)
                          (format-mode-line "%l:%c")
                          (doom-modeline-spc))
                  'face face)))
  (doom-modeline-def-segment nhe/buffer-simple
    "The buffer name but simpler."
    (let* ((active (doom-modeline--active))
           (face (cond ((and buffer-file-name (buffer-modified-p)) 'doom-modeline-buffer-modified)
                       (active 'doom-modeline-buffer-file)
                       (t 'mode-line-inactive))))
      (concat (doom-modeline-spc)
              (propertize "%b" 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment nhe/default-directory
    "The buffer directory."
    (let* ((active (doom-modeline--active))
           (face (if active 'doom-modeline-buffer-path 'mode-line-inactive)))
      (concat (doom-modeline-spc)
              (propertize (abbreviate-file-name default-directory) 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment nhe/flycheck
    "The error status with color codes and icons."
    (when (bound-and-true-p flycheck-mode)
      (let ((active (doom-modeline--active))
            (icon doom-modeline--flycheck-icon)
            (text doom-modeline--flycheck-text))
        (concat
         (when icon
           (concat (doom-modeline-spc)
                   (if active icon (doom-modeline-propertize-icon icon 'mode-line-inactive))))
         (when text
           (concat (if icon (doom-modeline-vspc) (doom-modeline-spc))
                   (if active text (propertize text 'face 'mode-line-inactive))))
         (when (or icon text)
           (doom-modeline-spc))))))
  (doom-modeline-def-segment nhe/info
    "The topic and nodes in Info buffers."
    (let ((active (doom-modeline--active)))
      (concat
       (propertize " (" 'face (if active 'mode-line 'mode-line-inactive))
       (propertize (if (stringp Info-current-file)
                       (replace-regexp-in-string
                        "%" "%%"
                        (file-name-sans-extension (file-name-nondirectory Info-current-file)))
                     (format "*%S*" Info-current-file))
                   'face (if active 'doom-modeline-info 'mode-line-inactive))
       (propertize ") " 'face (if active 'mode-line 'mode-line-inactive))
       (when Info-current-node
         (propertize (concat (replace-regexp-in-string "%" "%%" Info-current-node)
                             (doom-modeline-spc))
                     'face (if active 'doom-modeline-buffer-path 'mode-line-inactive))))))
  (doom-modeline-def-segment nhe/major-mode
    "The current major mode, including environment information."
    (let* ((active (doom-modeline--active))
           (face (if active 'doom-modeline-buffer-major-mode 'mode-line-inactive)))
      (concat (doom-modeline-spc)
              (propertize (format-mode-line mode-name) 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment nhe/process
    "The ongoing process details."
    (let ((result (format-mode-line mode-line-process)))
      (concat (if (doom-modeline--active)
                  result
                (propertize result 'face 'mode-line-inactive))
              (doom-modeline-spc))))
  (doom-modeline-def-segment nhe/space
    "A simple space."
    (doom-modeline-spc))
  (doom-modeline-def-segment nhe/vcs
    "The version control system information."
    (when-let ((branch doom-modeline--vcs-text))
      (let ((active (doom-modeline--active))
            (text (concat ":" branch)))
        (concat (doom-modeline-spc)
                (if active text (propertize text 'face 'mode-line-inactive))
                (doom-modeline-spc)))))
  (doom-modeline-mode 1)
  (doom-modeline-def-modeline 'info
    '(bar modals nhe/buffer nhe/info nhe/buffer-position selection-info)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'main
    '(bar modals nhe/buffer remote-host nhe/buffer-position nhe/flycheck selection-info)
    '(irc-buffers matches nhe/process nhe/vcs debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'message
    '(bar modals nhe/buffer-simple nhe/buffer-position selection-info)
    '(irc-buffers matches nhe/process nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'org-src
    '(bar modals nhe/buffer-simple nhe/buffer-position nhe/flycheck selection-info)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'package
    '(bar modals nhe/space package)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'project
    '(bar modals nhe/default-directory)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'special
    '(bar modals nhe/buffer nhe/buffer-position selection-info)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name))
  (doom-modeline-def-modeline 'vcs
    '(bar modals nhe/buffer remote-host nhe/buffer-position selection-info)
    '(irc-buffers matches nhe/process debug nhe/major-mode workspace-name)))

(use-package treemacs
  :config
  (treemacs-git-mode 'deferred))

(use-package treemacs-evil
  :after evil)

(use-package treemacs-projectile
  :after treemacs)
  
(use-package treemacs-magit
  :after treemacs)

(use-package treemacs-all-the-icons
  :after treemacs
  :config
  (treemacs-load-theme "all-the-icons"))

(use-package centaur-tabs
  :config
  (setq centaur-tabs-height 32)
  (setq centaur-tabs-bar-height 35)
  (setq centaur-tabs-set-bar 'under)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-greyout-icons t)
  (setq centaur-tabs-icon-scale-factor 0.75)
  ;; (setq centaur-tabs-icon-v-adjust -0.1)
  (setq x-underline-at-descent-line t)
  (centaur-tabs-mode 1))

(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items '((recents . 10)
			    (projects . 10)))
    (setq dashboard-show-shortcuts nil
          dashboard-banner-logo-title "Welcome to The Nerdy Hamster Emacs"
          dashboard-set-file-icons t
          dashboard-set-heading-icons t
          dashboard-startup-banner 'logo
          dashboard-set-navigator t
          dashboard-navigator-buttons
    `(((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
              "Github"
	      "Browse homepage"
              (lambda (&rest _) (browse-url "https://github.com/TheNerdyHamster/The-Nerdy-Hamster-Emacs")))
            (,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
              "Linkedin"
              "My Linkedin"
              (lambda (&rest _) (browse-url "https://www.linkedin.com/in/leo-ronnebro/" error)))
	  ))))
  :config
  (setq dashboard-center-content t)
  (dashboard-setup-startup-hook))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.4))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-unset-key (kbd "C-SPC"))

(use-package general
  :config
  (general-auto-unbind-keys)
  (general-override-mode +1)

  (general-create-definer nhe/leader-key
    :states '(normal insert visual emacs treemacs)
    :keymap 'override
    :prefix "SPC"
    :global-prefix "C-SPC"
    :non-normal-prefix "C-SPC")

  (general-create-definer nhe/local-leader-key
    :states '(normal insert visual emacs treemacs)
    :keymap 'override
    :prefix "SPC m"
    :global-prefix "C-SPC m"
    :non-normal-prefix "C-SPC m"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(nhe/leader-key 
  "/"   '(evilnc-comment-or-uncomment-lines :wk "comment/uncomment")
  ";"   '(counsel-M-x :wk "M-x")
  "."   '(counsel-find-file :wk "find file")
  "SPC" '(counsel-projectile-find-file :wk "find file project")
  "TAB" '(evil-switch-to-windows-last-buffer :wk "switch to previous buffer"))

(nhe/leader-key
  "b"   '(:ignore t :wk "buffer")
  "b b" '(counsel-switch-buffer :wk "switch buffer")
  "b d" '(kill-current-buffer :wk "kill buffer")
  "b i" '(ibuffer-list-buffers :wk "ibuffer")
  "b s" '(save-buffer :wk "save buffer")
  "b p" '(evil-prev-buffer :wk "prev buffer")
  "b n" '(evil-next-buffer :wk "next buffer"))

(nhe/leader-key
  "f" '(:ignore f :wk "file")
  "f f" '(counsel-find-file :wk "find file")
  "f s" '(save-buffer :wk "save file")
  "f r" '(recover-file :wk "recover file"))

(nhe/leader-key
  "h" '(:ignore t :wk "help")
  "h f" '(describe-function :wk "describe function")
  "h k" '(describe-key :wk "describe key")
  "h m" '(describe-mode :wk "describe mode")
  "h b" '(describe-bindings :wk "describe bindings")
  "h v" '(describe-variable :wk "describe variable")
  "h p" '(describe-package :wk "describe package"))

(nhe/leader-key
  "m" '(:ignore t :wk "local-leader"))

(nhe/leader-key
  "o" '(:ignore t :wk "open")
  "o t" '(vterm :wk "open terminal")
  "o d" '(docker :wk "open docker")
  "o p" '(treemacs :wk "open sidebar"))

(nhe/leader-key
  "q" '(:ignore t :wk "quit")
  "q q" '(save-buffers-kill-emacs :wk "save and quit")
  "q Q" '(kill-emacs :wk "quit no-save")
  "q r" '(restart-emacs :wk "restart emacs"))

(nhe/leader-key
  "s" '(:ignore t :wk "search")
  "s s" '(swiper :wk "search buffer")
  "s p" '(counsel-projectile-rg :wk "search project"))

(nhe/leader-key
  "t" '(:ignore t :wk "toggle"))

(nhe/leader-key
  "w" '(:ignore t :wk "window")
  "w w" '(other-window :wk "other window")
  "w d" '(evil-window-delete :wk "remove window")
  "w o" '(delete-other-windows :wk "remove other windows")
  "w h" '(evil-window-split :wk "split window horizontally")
  "w v" '(evil-window-vsplit :wk "split window vertically"))

(nhe/local-leader-key
  :keymaps 'prog-mode
  "=" '(:ignore t :wk "format")
  "d" '(:ignore t :wk "documentation")
  "g" '(:ignore t :wk "goto")
  "i" '(:ignore t :wk "insert"))

(use-package hydra
  :config
  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" (text-scale-adjust 0.1) "in")
    ("k" (text-scale-adjust -0.1) "out")
    ("f" nil "finished" :exit t))
    
  (nhe/leader-key
    "t s" '(hydra-text-scale/body :wk "scale text")))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)
  (counsel-mode 1)) 

(use-package smex 
  :defer 1
  :after counsel)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun he/org-font-setup ()
;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; Set faces for heading levels
(dolist (face '((org-level-1 . 1.1)
                (org-level-2 . 1.05)
                (org-level-3 . 1.0)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Fira Code NF" :weight 'regular :height (cdr face)))

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun he/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . he/org-mode-setup)
  :config
  (setq org-ellipsis " ...")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/Documents/Org/Tasks.org"
          "~/Documents/Org/Habits.org"
          "~/Documents/Org/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-note")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Documents/Org/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Documents/Org/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Documents/Org/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Documents/Org/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Documents/Org/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (he/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun he/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . he/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(defun nhe/org-babel-tangle-config ()
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle)))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'nhe/org-babel-tangle-config 
                                              'run-at-end 'only-in-org-mode)))

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

(use-package smartparens
  :init (smartparens-global-mode 1)
  :config
  (advice-add #'yas-expand :before #'sp-remove-active-pair-overlay))

(use-package undo-tree
  :init (global-undo-tree-mode 1)
  :config
  (defhydra hydra-undo-tree (:timeout 4)
    "undo / redo"
    ("u" undo-tree-undo "undo")
    ("r" undo-tree-redo "redo")
    ("t" undo-tree-visualize "undo-tree visualize" :exit t))

  (nhe/leader-key
    "u" '(hydra-undo-tree/body :wk "undo/redo")))

(use-package multiple-cursors
  :config
  (nhe/leader-key
    "c n" '(mc/mark-next-line-like-this :wk "mc-mark and next")
    "c w" '(mc/mark-prev-line-like-this :wk "mc-mark and prev")))

(use-package super-save
  :ensure t
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
          ("<tab>" . company-complete-selection))
         (:map lsp-mode-map
          ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :config
  (setq company-backends '(company-capf))
  (setq company-auto-commit t))

(use-package company-prescient
  :init (company-prescient-mode 1))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(use-package js2-mode
  :mode "\\/.*\\.js\\'"
  :config
  (setq js-indent-level 2)
  :hook (js-mode . yas-minor-mode))

(use-package rjsx-mode
  :mode "components\\/.*\\.js\\'")

(use-package js-doc
  :after js2-mode
  :config
  (nhe/local-leader-key
    :keymaps '(js2-mode rsjx-mode)
    "d" '(:ignore t :which-key "jsdoc")
    "d f" '(js-doc-insert-function-doc :wk "jsdoc function")))

(use-package js-react-redux-yasnippets
  :after (yasnippet js2-mode)
  :config
  (nhe/local-leader-key
    :keymaps '(js2-mode-map rsjx-mode)
    "i s" '(yas-insert-snippet :which-key "insert snippet")))

(use-package prettier
  :after js2-mode
  :config
  (nhe/local-leader-key
    :keymaps '(js2-mode-map rsjx-mode)
    "= =" '(prettier-prettify :which-key "format with prettier")))

(use-package web-mode)

(use-package go-mode
  :mode "\\.go\\'")
 
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package csharp-mode
  :hook
  (csharp-mode . rainbow-delimiters-mode)
  (csharp-mode . company-mode)
  (csharp-mode . flycheck-mode)
  (csharp-mode . omnisharp-mode)
)

(use-package omnisharp
  :after csharp-mode company
  :commands omnisharp-install-server
  :config
  (setq indent-tabs-mode nil
        c-syntactic-indentation t
        c-basic-offset 2
        tab-width 2
        evil-shift-width 2)
  (nhe/leader-key
    "o" '(:ignore o :which-key "omnisharp")
    "o r" '(omnisharp-run-code-action-refactoring :which-key "omnisharp refactor")
    "o b" '(recompile :which-key "omnisharp build/recompile")
    )
  (add-to-list 'company-backends 'company-omnisharp))

(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(defun he/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . he/lsp-mode-setup)
        (typescript-mode . lsp-deferred)
        (js2-mode . lsp-deferred)
        (rsjx-mode . lsp-deferred)
        (scss-mode . lsp-deferred)
        (web-mode . lsp-deferred)
        (go-mode . lsp-deferred)
        (csharp-mode . lsp-deferred))
  :config
  (setq lsp-completion-provider :capf)
  (lsp-enable-which-key-integration t)
  (nhe/local-leader-key
    :keymaps '(js2-mode-map
               rjsx-mode-map
               typescript-mode-map
               csharp-mode
               lsp-mode-map
               lsp-ui-mode-map)
    "g r" '(lsp-ui-peek-find-references :which-key "goto references")
    "g g" '(lsp-find-definition :which-key "goto definition")
    "o" '(lsp-ui-imenu :which-key "overview")
    "r" '(:ignore t :which-key "refactor")
    "r r" '(lsp-rename :which-key "rename")
    "=" '(:ignore t :which-key "format")
    "= l" '(lsp-format-buffer :which-key "format with lsp")))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))
  ;; :custom
  ;; (setq lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package flycheck
  :hook (after-init-hook . global-flycheck-mode)
  :config
  (nhe/leader-key
    "e" '(:ignore t :which-key "errors")
    "e l" '(flycheck-list-errors :which-key "list errors")
    )
  )

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :config
  (nhe/leader-key
    "g" '(:ignore t :wk "git")
    "g s" '(magit-status :wk "magit status")
    "g b" '(magit-branch :wk "maigt branch")
    "g B" '(magit-blame :wk "magit blame")))

(use-package evil-magit
  :after magit)

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)

(use-package docker
  :ensure t)

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

;; If you want to pull in the Evil compatibility package.
(use-package kubernetes-evil
  :ensure t
  :after kubernetes)

(use-package yasnippet-snippets)

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

(use-package evil-nerd-commenter)

(use-package expand-region)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :config
  (rainbow-mode 1))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package elcord
  :config
  (elcord-mode 1))

(use-package wakatime-mode 
  :defer 2
  :config
  (setq wakatime-api-key nhe/waka-time-token)
  (global-wakatime-mode))
