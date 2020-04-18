;; ------------------------------
;; custom .emacs
;; ------------------------------

;; owner: gpio.dev

;; Collection of hooks to customize my emacs environment typically these are
;; hooks that i have gathered from various websites like emacs wiki, emacs redux
;; etc. I have added references/credits wherever I can

;; Few references
;; - github.com/btskinner/.emacs
;; - http://shallowsky.com/blog/linux/editors/emacs-trailing-spaces.html

;; ------------------------------
;; editing
;; ------------------------------
;; language setting
;;(unless (get-lang "LANG") (setenv "LANG" "en_US.UTF-8"))

;; highlight selected region
(setq-default transient-mark-mode t)

;; show tabs and spaces
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "yellow")

;; delete trailing white spaces on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; bind to C-c C-d
(global-set-key "\C-c \C-d" 'delete-trailing-whitespace)

;; wrap lines with M-q on column 120
(setq-default fill-column 80)

;; auto-mode for verilog mode for system verilog, verilog,
;;               text-mode for README files
;;               org-mode for .org files (todo lists etc)
(setq auto-mode-alist (cons '("README" . text-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.org" . org-mode) auto-mode-alist))

;; remove startup message while emacs starts
(setq-default inhibit-startup-message t)
(setq-default initial-scratch-message "")

;; remove *Message* buffer - commented this section off since I'd like to see
;; Messages if there are startup errors

;; remove this while debugging lisp code
;; (setq-default message-log-max nil)
;; (kill-buffer "*Messages*")

;; disable the audio bell when emacs error
(setq-default ring-bell-function 'ignore)

;; enable line and column numbers by default
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'column-number-mode)

;; use aspell for ispell (auto-correct spelling)
;; on linux use, apt-get install aspell
(setq ispell-program-name "/usr/bin/aspell")

;; show parenthesis matching
(show-paren-mode 1)

;; line highlighting and region selection coloring

;; highlight the current line
(global-hl-line-mode +1)
;; refer color code here
;; http://www.creativecolorschemes.com/resources/free-color-schemes/beige-tone-color-scheme.shtml
;; #f6f6d6 - beige
;; there should be some names for these colors for me they are darker shades of
;; beige
;; #f2eecb - darker beige
;; #e1c699 - more darker  beige
(set-face-attribute 'hl-line nil :inherit nil :background "#f2eecb")

;; hghlight on search
;;(custom-set-variables )
(custom-set-faces
'(isearch ((((class color) (min-colors 8)) (:background "gray69" )))))

;; selected region highlighting


;; enable interactive do mode - helps auto complete/suggest file names etc
(require 'ido)
(ido-mode t)

;; ------------------------------
;;  handy key bindings
;; ------------------------------

;; toggle line wrapping
(global-set-key "\C-cw" 'toggle-truncate-lines)

;; use % to match parenthesis
(global-set-key "\%" 'match-paren)

;; f8 for revert buffer
(global-set-key [f8] 'revert-buffer)

;; f1 for go-to-line
(global-set-key [f1] 'goto-line)

;; alias y and n for yes and no
(defalias 'yes-or-no-p 'y-or-n-p)

;; open the .emacs init file
;; https://emacsredux.com/blog/2013/05/18/instant-access-to-init-dot-el
(defun er-find-user-init-file ()
  "Edit the `user-init-file` in another window"
  (interactive)
  (find-file-other-window user-init-file))

;; Bind C-x . to open .emacs file
(global-set-key "\C-c." 'er-find-user-init-file)

;; find file at point (if the cursor is on a path in a file, it will open the
;; file pointed to by the path)
(global-set-key (kbd "C-c C-p") 'find-file-at-point)

;; borrowed function from
;; https://gnu.org/software/emacs/manual/html_node/efaq/Matching-parenthesis.html
(defun match-paren (arg)
  "Go to the matching parenthesis if on a parenthesis; otherwise insert %"
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
	((looking-at "\\s)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

;; ------------------------------
;; x manager hooks
;; ------------------------------

;; maximize only initial frame
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (gprabhu)))
 '(custom-safe-themes
   (quote
    ("d187bc263671aeed1cb48d460e9fb700774bd666679dc59ceeb79379b4006b55" default)))
 '(global-whitespace-mode nil)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; while using ediff, fit ediff control buffer to smaller frame size
;; also highlight the ediff control frame as the default buffer to avoid using
;; the mouse to move control to this frame
;; reference https://www.emacswiki.org/emacs/EdiffMode
(add-hook 'ediff-startup-hook
          (lambda ()
            (progn
              (select-frame-by-name "Ediff")
              (set-frame-size (selected-frame) 10 10))))

;; always split vertically while diffing files - see diffs side by side
(setq ediff-split-window-function 'split-window-vertically)

;; setup ediff command line option to diff two files -
;; usage:
;; emacs -diff file and file2
;; reference https://www.emacswiki.org/emacs/EdiffMode
(defun command-line-diff (switch)
      (let ((file1 (pop command-line-args-left))
            (file2 (pop command-line-args-left)))
        (ediff file1 file2)))

(add-to-list 'command-switch-alist '("-diff" . command-line-diff))

;; remove backup and auto-save - I never really made use of these backup files and
;; had to clean them up all the time
(setq-default make-backup-files nil)
(setq-default auto-save-default nil)

;; ---------- editing ----------
;; indentation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; hide menu and tool bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; cursor type
(setq-default cursor-type 'box)

;; ---------- MELPA ----------
;; recommended to use emacs version > 24
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages"))

;; could use melpa stable if required
;;(add-to-list 'package-archives
;; (cons "melpa-stable" (concat proto "://melpa.org/packages/")) t)
;;(package-initialize)

;; local packages - uncomment if dependent on melpa
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;; disable signature checks for melpa packages
;;(setq package-check-signature nil)

;; from the melpa home page instructions
;; for emacs version lower than 24
;;(when (< emacs-major-version 24)
;;  ;; for compatibility libs like cl-libs
;;  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/"))))

;; ---------- cl-lib ----------
;;(require 'cl)

;; ---------- custom variables fonts ----------


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width condensed :foundry "misc" :family "monospace 10"))))
 '(region ((t (:background "white smoke" :distant-foreground "gtk_selection_fg_color"))))
 '(whitespace-trailing ((t (:background "red" :foreground "yellow" :weight bold)))))
;; '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 108 :width regular :foundry "Misc" :family "Fixed")))))
;; '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :foundry "Misc" :family "Fixed")))))


;; ---------- LaTex related configs ----------
;; requires AuCTex (installed using tar.gz)
;; reference https://gnu.org/software/auctex/download-for-unix.html

;; (load "preview-latex.el" nil t t)

;; pdflatex command as default
;; (setq LaTex-command "pdflatex -synctex=1")

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; tex-pdf mode by default
(setq TeX-PDF-mode t)

;; ---------- verilog stuff  ----------
;; load verilog mode
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t)
;; load .v, .sv and .dv files with verilog mode
(setq auto-mode-alist (cons '("\\.[ds]v" . verilog-mode) auto-mode-alist))

;; enable font-lock mode (keywords highlighted in verilog mode
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))

;; limit coloration for verilog mode to 2 and in all other modes to t
;; C-h v font-lock-maximum-coloration
;; Documentation:
;; Maximum decoration level for fontification.
;; If nil, use the default decoration (typically the minimum available).
;; If t, use the maximum decoration available.
;; If a number, use that level of decoration (or if not available the maximum).
;; The higher the number, the more decoration is done.
;; If a list, each element should be a cons pair of the form (MAJOR-MODE . LEVEL),
;; where MAJOR-MODE is a symbol or t (meaning the default).  For example:
;;  ((c-mode . t) (c++-mode . 2) (t . 1))
;; means use the maximum decoration available for buffers in C mode, level 2
;; decoration for buffers in C++ mode, and level 1 decoration otherwise.

(setq font-lock-maximum-decoration
      '(list (verilog-mode . 2) (t . t)))

;; veri-kompass
;; for verilog directory navigation
;; available in "~/.emacs/site-list/"
(require 'veri-kompass)
(add-hook 'verilog-mode-hook 'veri-kompass-minor-mode)

;; ---------- org mode ----------

;; enable the minor mode org indent mode to have cleaner org mode notes - hide stars etc
(add-hook 'org-mode-hook 'org-indent-mode)

;; start org in indented mode
(setq org-startup-indented t)

;; indentation to nil and hide leading stars; org-indent-mode would have done it anyway
(setq org-adapt-indentation nil)
(setq org-hide-leading-stars t)

;; disable bold
(defun remap-faces-default-attributes ()
  (let ((family (face-attribute 'default :family))
	(height (face-attribute 'default :height)))
    (mapcar (lambda (face)
	      (face-remap-add-relative
	       face :family family :weight 'normal :height height))
	    (face-list))))

(when (display-graphic-p)
  (add-hook 'minibuffer-setup-hook 'remap-faces-default-attributes)
  (add-hook 'change-major-mode-after-body-hook 'remap-faces-default-attributes))
(put 'dired-find-alternate-file 'disabled nil)

;; speedbar stuff
;;(require 'sr-speedbar)
(global-set-key (kbd "M-1") 'sr-speedbar-toggle)

(setq speedbar-use-images nil)
(setq speedbar-show-unknown-files t)

;; ---------- ediff hooks ----------
;; do not highlight diffs by whitespaces
;; user recommends using ## to ignore whitespace diffs while using ediff instead
;; of setting ignore similar regions
;; leaving this here to enable when required
;; (setq-default ediff-ignore-similar-regions t)
;; (setq-default ediff-highlight-all-diffs nil)
