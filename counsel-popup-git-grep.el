;;; counsel-popup-git-grep.el --- Interactive search with counsel-git-grep -*- lexical-binding: t; -*-

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

;; Just call the interactive function `counsel-popup-git-grep' and use the
;; popup to configure the search.

;;; Code:

(require 'counsel)
(require 'counsel-popup-core)

(transient-define-argument counsel-popup-git-grep:=c ()
  :description "Search blobs registered in the index file"
  :key "=c"
  :argument "--cached")

(transient-define-argument counsel-popup-git-grep:=i ()
  :description "Search also in untracked files"
  :key "=i"
  :argument "--untracked")

(transient-define-argument counsel-popup-git-grep:=u ()
  :description "Search files in the current directory that is not managed by Git"
  :key "=u"
  :argument "--no-index")

(transient-define-argument counsel-popup-git-grep:=e ()
  :description "Also search in ignored files"
  :key "=e"
  :argument "--no-exclude-standard")

(transient-define-argument counsel-popup-git-grep:=r ()
  :description "Recursively search in submodules"
  :key "=r"
  :argument "--recurse-submodules")

(transient-define-argument counsel-popup-git-grep:-a ()
  :description "Process binary files as if they were text"
  :shortarg "-a"
  :argument "--text")

(transient-define-argument counsel-popup-git-grep:-A ()
  :description "Print lines after match"
  :class 'transient-option
  :shortarg "-A"
  :argument "--after="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-git-grep:-B ()
  :description "Print lines before match"
  :class 'transient-option
  :shortarg "-B"
  :argument "--before="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-git-grep:-C ()
  :description "Print lines before and after matches"
  :class 'transient-option
  :shortarg "-C"
  :argument "--context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-git-grep:-p ()
  :description "Show the preceding line that contains the function name of the match"
  :shortarg "-p"
  :argument "--show-function")

(transient-define-argument counsel-popup-git-grep:-W ()
  :description "Show the surrounding text from the previous line containing a function name"
  :shortarg "-W"
  :argument "--function-context")

(transient-define-argument counsel-popup-git-grep:-r ()
  :description "Recursively search subdirectories listed"
  :shortarg "-r"
  :argument "--recursive")

(transient-define-argument counsel-popup-git-grep:-i ()
  :description "Match case insensitively"
  :shortarg "-i"
  :argument "--ignore-case")

(transient-define-argument counsel-popup-git-grep:-v ()
  :description "Invert match"
  :shortarg "-v"
  :argument "--invert-match")

(transient-define-argument counsel-popup-git-grep:-w ()
  :description "Only match whole words"
  :shortarg "-w"
  :argument "--word-regexp")

(transient-define-argument counsel-popup-git-grep:-G ()
  :description "Use POSIX basic regexp for patterns"
  :shortarg "-G"
  :argument "--basic-regexp")

(transient-define-argument counsel-popup-git-grep:-E ()
  :description "Use POSIX extended regexp for patterns"
  :shortarg "-E"
  :argument "--extended-regexp")

(transient-define-argument counsel-popup-git-grep:-P ()
  :description "Use Perl-compatible regular expressions for patterns"
  :shortarg "-P"
  :argument "--perl-regexp")

(transient-define-argument counsel-popup-git-grep:-F ()
  :description "Use fixed strings for patterns"
  :shortarg "-F"
  :argument "--fixed-strings")

(defun counsel-popup-git-grep-search-project (&optional string)
  "Search using `counsel-git-grep' in the current project for STRING."
  (interactive)
  (counsel-popup-git-grep-search nil string))

(defun counsel-popup-git-grep-search (directory &optional string)
  "Search using `counsel-git-grep' in a given DIRECTORY for STRING."
  (interactive "DDirectory: ")
  (let* ((search-args (counsel-popup--map-args (transient-args 'counsel-popup-git-grep)))
         (cmd (concat counsel-git-grep-cmd-default " " search-args)))
    (counsel-git-grep string directory cmd)))

(transient-define-prefix counsel-popup-git-grep ()
  "Search popup using `counsel-git-grep'."
  :man-page "git-grep"
  ["Output options"
   (counsel-popup-git-grep:=c)
   (counsel-popup-git-grep:=i)
   (counsel-popup-git-grep:=u)
   (counsel-popup-git-grep:=e)
   (counsel-popup-git-grep:=r)
   (counsel-popup-git-grep:-a)
   (counsel-popup-git-grep:-A)
   (counsel-popup-git-grep:-B)
   (counsel-popup-git-grep:-C)
   (counsel-popup-git-grep:-p)
   (counsel-popup-git-grep:-W)]
  ["Search options"
   (counsel-popup-git-grep:-i)
   (counsel-popup-git-grep:-r)
   (counsel-popup-git-grep:-v)
   (counsel-popup-git-grep:-w)]
  ["Regexp"
   (counsel-popup-git-grep:-G)
   (counsel-popup-git-grep:-E)
   (counsel-popup-git-grep:-P)
   (counsel-popup-git-grep:-F)]
  ["Search"
   ("s" "in project" counsel-popup-git-grep-search-project)
   ("o" "in other directory" counsel-popup-git-grep-search)])

(provide 'counsel-popup-git-grep)
;;; counsel-popup-git-grep.el ends here
