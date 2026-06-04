;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(xterm-mouse-mode 1)

;; like vim's "scrolloff"
(setq scroll-margin 2)

;; toggle line numbers <leader>n (lower)
;; this version (n) does NOT mess with the git-signs column.
(defun my/toggle-line-numbers ()
  "Toggle line numbers (excludes git signs)."
  (interactive)
  (if (eq display-line-numbers 'relative)
      (setq display-line-numbers nil)
    (setq display-line-numbers 'relative)))

(map! :leader :desc "Toggle line number gutter" "n" #'my/toggle-line-numbers)

;; toggle line number / git-signs gutter with <leader>N (upper)
;; this version (N) ALSO toggles the git-signs column.
(defun my/toggle-linenum-git-gutter ()
  "Toggle line number gutter (INCLUDES git signs)."
  (interactive)
  (if (eq display-line-numbers 'relative)
      (setq display-line-numbers nil)
    (setq display-line-numbers 'relative))
  (diff-hl-mode 'toggle))

(map! :leader :desc "Toggle line numbers and git signs" "N" #'my/toggle-linenum-git-gutter)

;; macos system pasteboard interaction:
;;
;; - if a region is marked, copy to system clipboard with <leader>y
;;   - if no region marked, copy current line instead
;; - paste from system clipboard with <leader>p
;;   - paste before cursor with <leader>P

(defun my/copy-to-clipboard (start end)
  "Copy region or current line to macOS clipboard."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (line-beginning-position) (line-end-position))))
  (shell-command-on-region start end "pbcopy")
  (deactivate-mark))

(defun my/paste-from-clipboard ()
  "Paste from macOS clipboard."
  (interactive)
  (insert (shell-command-to-string "pbpaste")))

(defun my/paste-before-from-clipboard ()
  "Paste from macOS clipboard before cursor."
  (interactive)
  (save-excursion
    (insert (shell-command-to-string "pbpaste"))))

(map! :leader
      :desc "Copy to clipboard"             "y" #'my/copy-to-clipboard
      :desc "Paste from clipboard"          "p" #'my/paste-from-clipboard
      :desc "Paste (before) from clipboard" "P" #'my/paste-before-from-clipboard)

;; do not send cut/kill-ring text to system clipboard automatically
(setq select-enable-clipboard nil)

;; change cursor shape by mode. reset on exit.
(defun my/set-cursor-shape (shape)
  "Send escape sequence to set terminal cursor shape."
  (let ((seq (pcase shape
               ('box  "\e[1 q")
               ('bar  "\e[5 q")
               ('hbar "\e[3 q"))))
    (when seq (send-string-to-terminal seq))))

(add-hook 'evil-insert-state-entry-hook  (lambda () (my/set-cursor-shape 'bar)))
(add-hook 'evil-replace-state-entry-hook (lambda () (my/set-cursor-shape 'hbar)))
(add-hook 'evil-normal-state-entry-hook  (lambda () (my/set-cursor-shape 'box)))
(add-hook 'evil-visual-state-entry-hook  (lambda () (my/set-cursor-shape 'box)))
(add-hook 'evil-emacs-state-entry-hook   (lambda () (my/set-cursor-shape 'hbar)))

(add-hook 'kill-emacs-hook (lambda () (my/set-cursor-shape 'box)))


(with-eval-after-load 'evil
  ;; reach for the <escape> key less
  (setq evil-escape-key-sequence "kj")
  (setq evil-escape-delay 0.3)

  ;; move up/down by line visually even with line wrap on
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; vim-style incr/decr for numeric values
  (evil-global-set-key 'normal (kbd "C-a") #'evil-numbers/inc-at-pt-incremental)
  (evil-global-set-key 'normal (kbd "C-x") #'evil-numbers/dec-at-pt-incremental))


(with-eval-after-load 'org
  (setq org-startup-folded 'content)

  ;; org-mode: todo keywords
  (setq org-todo-keywords
        '((sequence "TODO" "NEXT" "|" "DONE" "CANCELED" "DELEGATED" )))
  (setq org-todo-keyword-faces
        '(("TODO"      . (:foreground "green"      :weight bold))
          ("NEXT"      . (:foreground "orange"     :weight bold))
          ("DONE"      . (:foreground "slate gray" :weight bold))
          ("CANCELED"  . (:foreground "slate gray" :weight bold))
          ("DELEGATED" . (:foreground "slate gray" :weight bold))))

  ;; how to open links
  ;; most of this is defaults; I added jpg, png and changed pdf to use `open`
  (setq org-file-apps '((remote . emacs)
                        (auto-mode . emacs)
                        (directory . emacs)
                        ("\\.mm\\'" . default)
                        ("\\.x?html?\\'" . default)
                        ("\\.pdf\\'" . "open %s")
                        ("\\.jpg\\'" . "open %s")
                        ("\\.png\\'" . "open %s")))

  (add-hook! 'org-mode-hook
    ;; digraph support with ^k, in insert mode, in org-mode.
    ;; this took a surprising number of rounds back and forth with claude
    ;; to find something that actually worked.
    (evil-local-set-key 'insert (kbd "C-k") #'evil-insert-digraph)
    ;; { and } to jump among headings in org files
    (evil-local-set-key 'normal (kbd "{") #'org-previous-visible-heading)
    (evil-local-set-key 'normal (kbd "}") #'org-next-visible-heading)))
