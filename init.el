;;;;;;;;;;;;;
;; Preamble;;
;;;;;;;;;;;;;
;;; Setup

;; -- Vishakh Kumar's Spacemacs Configuration --
;; -- Contact: vishakhpradeepkumar@gmail.com --
;; -- http://grokkingStuff.org --
;; -- GPLv3 License --

(setq user-full-name "Vishakh Kumar"
      user-mail-address "vishakhpradeepkumar@gmail.com")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spacemacs Layers Variable Instantiation;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar dotspacemacs/layers/langs
  '(
   ;; Markups
    csv
    html
    markdown
    yaml
    org
    asciidoc

    ;; Languages
    c-c++
    emacs-lisp
    javascript
    (haskell :variables
             haskell-completion-backend 'intero)
    (python :variables
            python-sort-imports-on-save t
            python-test-runner 'pytest
            :packages
            (not hy-mode)  ; I maintain local `hy-mode'
            (not importmagic))  ; Broken? Don't need it.
   )
)
(defvar dotspacemacs/layers/extra
  '(gnus
    graphviz
    pdf-tools
    ranger

    (ibuffer :variables
             ibuffer-group-buffers-by 'projects))
)
(defvar dotspacemacs/layers/communication
  '(slack    ;; There's no escaping the beast.
    mu4e     ;; Decent email client
    twitter  ;; Because Twitter is addictive
    elfeed   ;; RSS and Atom feeds
   )

)
(defvar dotspacemacs/layers/sourceControl
  '(git
    github
    magit
   )
)

;;;;;;;;;;;;;;;;;;;;
;; Personal Config;;
;;;;;;;;;;;;;;;;;;;;
(evil-mode)
(load-theme 'monokai)
(add-hook 'visual-line-mode)
(setq-default fill-column 80)
(global-linum-mode 1)
(defun org-html-export-on-save ()
  (interactive)
  (if (memq 'org-html-export-to-html after-save-hook)
      (progn
        (remove-hook 'after-save-hook 'org-html-export-to-html t)
        (message "Disabled org html export on save for current buffer..."))
    (add-hook 'after-save-hook 'org-html-export-to-html nil t)
    (message "Enabled org html export on save for current buffer...")
  )
)

(defun org-markdown-export-on-save ()
  (interactive)
  (if (memq 'org-html-export-to-html after-save-hook)
      (progn
        (remove-hook 'after-save-hook 'org-markdown-export-to-markdown t)
        (message "Disabled org markdown export on save for current buffer..."))
    (add-hook 'after-save-hook 'org-markdown-export-to-markdown nil t)
    (message "Enabled org markdown export on save for current buffer...")
  )
)

(defun org-pdf-export-on-save ()
  (interactive)
  (if (memq 'org-pdf-export-to-pdf after-save-hook)
      (progn
        (remove-hook 'after-save-hook 'org-pdf-export-to-pdf t)
        (message "Disabled org pdf export on save for current buffer..."))
    (add-hook 'after-save-hook 'org-pdf-export-to-pdf nil t)
    (message "Enabled org pdf export on save for current buffer...")
  )
)

;; Add hook for doing this on every org file:
(add-hook 'org-mode-hook 'org-html-export-on-save)
(add-hook 'org-mode-hook 'org-markdown-export-on-save)
(add-hook 'org-mode-hook 'org-pdf-export-on-save)
(setq org-startup-indented t)
(add-hook 'org-mode-hook 'visual-line-mode)
;;; Allow org-mode to eval source code
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   )
)
(defun open-with (arg)
  "Open visited file in default external program.

With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (shell-command (concat
                    (cond
                     ((and (not arg) (eq system-type 'darwin)) "open")
                     ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                     (t (read-shell-command "Open current file with: ")))
                    " "
                    (shell-quote-argument buffer-file-name)))))
(global-set-key (kbd "C-c o") 'open-with)


;;;;;;;;;;;;;;;;;;;;;;
;; Window Management;;
;;;;;;;;;;;;;;;;;;;;;;
(use-package windmove
  :bind
  (("<f2> <right>" . windmove-right)
   ("<f2> <left>" . windmove-left)
   ("<f2> <up>" . windmove-up)
   ("<f2> <down>" . windmove-down)
   ))
(use-package switch-window
  :bind (("C-x o" . switch-window)))
