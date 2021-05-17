;;; counsel-popup-grep.el --- Interactive search with counsel-grep -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2021  Eder Elorriaga

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Just call the interactive function `counsel-popup-grep' and use the
;; popup to configure the search.

;;; Code:

(require 'counsel)
(require 'counsel-popup-core)

(transient-define-argument counsel-popup-grep:-A ()
  :description "Print lines after match"
  :class 'transient-option
  :shortarg "-A"
  :argument "--after="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-grep:-B ()
  :description "Print lines before match"
  :class 'transient-option
  :shortarg "-B"
  :argument "--before="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-grep:-C ()
  :description "Print lines before and after matches"
  :class 'transient-option
  :shortarg "-C"
  :argument "--context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-grep:-r ()
  :description "Recursively search subdirectories listed"
  :shortarg "-r"
  :argument "--recursive")

(transient-define-argument counsel-popup-grep:-S ()
  :description "If -r is specified, all symbolic links are followed."
  :argument "-S")

(transient-define-argument counsel-popup-grep:-i ()
  :description "Match case insensitively"
  :shortarg "-i"
  :argument "--ignore-case")

(transient-define-argument counsel-popup-grep:-v ()
  :description "Invert match"
  :shortarg "-v"
  :argument "--invert-match")

(transient-define-argument counsel-popup-grep:-w ()
  :description "Only match whole words"
  :shortarg "-w"
  :argument "--word-regexp")

(transient-define-argument counsel-popup-grep:-x ()
  :description "Only match whole lines"
  :shortarg "-x"
  :argument "--line-regexp")

(defun counsel-popup-grep-search ()
  "Search for STRING using `counsel-grep' in the file visited by the current buffer."
  (interactive)
  (let* ((search-args (counsel-popup--map-args (transient-args 'counsel-popup-grep)))
         (counsel-grep-base-command (concat counsel-grep-base-command " " search-args)))
    (message "search-args: %s" search-args)
    (counsel-grep)))

(transient-define-prefix counsel-popup-grep ()
  "Search popup using `counsel-grep'."
  :man-page "grep"
  ["Output options"
   (counsel-popup-grep:-A)
   (counsel-popup-grep:-B)
   (counsel-popup-grep:-C)]
  ["Search options"
   (counsel-popup-grep:-i)
   (counsel-popup-grep:-r)
   (counsel-popup-grep:-S)
   (counsel-popup-grep:-v)
   (counsel-popup-grep:-w)
   (counsel-popup-grep:-x)]
  ["Search"
   ("s" "in current file" counsel-popup-grep-search)])

(provide 'counsel-popup-grep)
;;; counsel-popup-grep.el ends here
