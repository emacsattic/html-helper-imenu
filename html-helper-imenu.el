;;; html-helper-imenu --- imneu suport for html-helper
;;
;; ~/share/emacs/pkg/html/html-helper-imenu.el ---
;;
;; $Id: html-helper-imenu.el,v 1.11 2004/03/23 07:39:37 harley Exp $
;;

;; Author:    Harley Gorrell <harley@panix.com>
;; URL:       http://www.mahalito.net/~harley/elisp/html-helper-imenu.el
;; License:   GPL v2
;; Keywords:  html-helper, imenu, html, table of contents

;;; Commentary:
;; * Adds an indented table of contents to the menubar
;; * The regexp only matches headers on a single line
;;   and well formed tags.  (Which is pretty common.)
;;
;; Put somthing like the following in your .emacs:
;; (autoload 'html-helper-imenu-setup "html-helper-imenu")
;; (add-hook 'html-helper-mode-hook 'html-helper-imenu-setup)
;;
;; While this was originaly written for html-helper,
;; It will work with sgml-mode and others.
;;
;; http://www.santafe.edu/~nelson/hhm-beta/html-helper-mode.el

;;; History:
;;
;; 1998-06-25 : added regexp
;; 2003-03-18 : updated contact info
;; 2004-03-22 : minor clean up

;;; Code:

(defvar html-helper-imenu-title "TOC"
  "*Title of the menu which will be added to the menubar.")

(defvar html-helper-imenu-regexp
  "\\s-*<h\\([1-9]\\)[^\n<>]*>\\(<[^\n<>]*>\\)*\\s-*\\([^\n<>]*\\)"
  "*A regular expression matching a head line to be added to the menu.
The first `match-string' should be a number from 1-9.
The second `match-string' matches extra tags and is ignored.
The third `match-string' will be the used in the menu.")

;; Make an index for imenu
(defun html-helper-imenu-index ()
  "Return an table of contents for an html buffer for use with Imenu."
  (let ((space ?\ ) ; a char
	(toc-index '())
	toc-str)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward html-helper-imenu-regexp nil t)
	(setq toc-str
	      (concat
	       (make-string
		(* 2 (- (string-to-number (match-string 1)) 1))
		space)
	       (match-string 3)))
	(beginning-of-line)
	(setq toc-index (cons (cons toc-str (point)) toc-index))
	(end-of-line) ))
    (nreverse toc-index)))

(defun html-helper-imenu-bogus ()
  "A bougus function to make the 20.2 version of imenu happy.
Otherwise it the mode wont activate."
  (error "Imenu called html-helper-imenu-bogus"))

(defun html-helper-imenu-setup ()
  "Setup the variables to support imenu."
  (interactive)
  (setq imenu-create-index-function 'html-helper-imenu-index)
  (setq imenu-extract-index-name-function 'html-helper-imenu-bogus)
  (setq imenu-sort-function nil) ; sorting the menu defeats the purpose
  (imenu-add-to-menubar html-helper-imenu-title))

(provide 'html-helper-imenu)

;;; html-helper-imenu ends here
