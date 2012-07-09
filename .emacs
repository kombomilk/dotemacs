;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;; comment-syntax

(setq comment-start "#")

;;; enable UTF-8 encoding

(set-language-environment "UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")
(setq slime-net-coding-system 'utf-8-unix)

;;; emacs-w3m
(require 'w3m-load)

;;; auto-complete
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

;;; fortunes

(defvar fortune-file "/home/sergey/.emacs.d/fortunes.txt"
"The file that fortunes come from.")

(defvar fortune-strings nil
  "The fortunes in the fortune file.")

(defun open-fortune-file (file)
  (find-file file)
  (if (null fortune-strings)
      (let ((strings nil)
        (prev 1))
    (goto-char (point-min))
    (while (re-search-forward "^%$" (point-max) t)
      (push (buffer-substring-no-properties prev (- (point) 1))
            strings)
      (setq prev (1+ (point))))
    (push (buffer-substring-no-properties prev (point-max)) strings)
    (setq fortune-strings (apply 'vector strings)))))

(defun fortune ()
  "Get a fortune to display."
  (interactive)
  (when (null fortune-strings)
    (open-fortune-file fortune-file)
    (kill-buffer (current-buffer)))
  (let* ((n (random (length fortune-strings)))
     (string (aref fortune-strings n)))
    (if (interactive-p)
    (message (format "%s" string))
      string)))

(defun startup-echo-area-message ()
  (interactive)
  (let ((start (point))
        (buffer-was-modified? (buffer-modified-p)))
    (insert (fortune))
    (comment-region start (point))
    (newline)
    (unless buffer-was-modified?
      (not-modified))))
