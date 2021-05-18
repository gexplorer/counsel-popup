;;; counsel-popup-ag.el --- Interactive search with counsel-ag -*- lexical-binding: t; -*-

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

;; Just call the interactive function `counsel-popup-ag' and use the
;; popup to configure the search.

;;; Code:

(require 'counsel)
(require 'counsel-popup-core)

(defcustom counsel-popup-ag-file-type-list
  '("actionscript" "ada" "asciidoc" "asm" "batch" "bitbake" "bro" "cc" "cfmx"
    "chpl" "clojure" "coffee" "cpp" "crystal" "csharp" "css" "cython" "delphi"
    "dot" "ebuild" "elisp" "elixir" "elm" "erlang" "factor" "fortran" "fsharp"
    "gettext" "glsl" "go" "groovy" "haml" "handlebars" "haskell" "haxe" "hh"
    "html" "ini" "ipython" "jade" "java" "js" "json" "jsp" "julia" "kotlin"
    "less" "liquid" "lisp" "log" "lua" "m4" "make" "mako" "markdown" "mason"
    "matlab" "mathematica" "md" "mercury" "nim" "nix" "objc" "objcpp" "ocaml"
    "octave" "org" "parrot" "perl" "php" "pike" "plist" "plone" "proto" "puppet"
    "python" "qml" "racket" "rake" "restructuredtext" "rs" "r" "rdoc" "ruby"
    "rust" "salt" "sass" "scala" "scheme" "shell" "smalltalk" "sml" "sql"
    "stylus" "swift" "tcl" "tex" "tt" "toml" "ts" "twig" "vala" "vb" "velocity"
    "verilog" "vhdl" "vim" "wix" "wsdl" "wadl" "xml" "yaml")
  "List of supported file types for `counsel-popup-ag'."
  :group 'counsel-popup
  :type '(repeat string))

(defun counsel-popup-ag-read-pattern (prompt initial-input history)
  "Read a pattern from the minibuffer, prompting with string PROMPT.

If non-nil, second arg INITIAL-INPUT is a string to insert before reading.
The third arg HISTORY, if non-nil, specifies a history."
  (read-string prompt initial-input history))

(transient-define-argument counsel-popup-ag:-- ()
  "Restrict the search to certain types of files."
  :description "Limit to file types"
  :class 'counsel-popup-file-types
  :key "--"
  :argument "--"
  :prompt "Limit to file type(s): "
  :multi-value t
  :choices counsel-popup-ag-file-type-list)

(transient-define-argument counsel-popup-ag:-A ()
  :description "Print lines after match"
  :class 'transient-option
  :shortarg "-A"
  :argument "--after="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-ag:-B ()
  :description "Print lines before match"
  :class 'transient-option
  :shortarg "-B"
  :argument "--before="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-ag:-C ()
  :description "Print lines before and after matches"
  :class 'transient-option
  :shortarg "-C"
  :argument "--context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-ag:=h ()
  :description "Search hidden files"
  :shortarg "=h"
  :argument "--hidden")

(transient-define-argument counsel-popup-ag:-f ()
  :description "Follow symlinks"
  :shortarg "-f"
  :argument "--follow")

(transient-define-argument counsel-popup-ag:-G ()
  :description "Limit search to filenames matching PATTERN"
  :class 'transient-option
  :shortarg "-G"
  :argument "--file-search-regex="
  :reader 'counsel-popup-ag-read-pattern)

(transient-define-argument counsel-popup-ag:-i ()
  :description "Match case insensitively"
  :shortarg "-i"
  :argument "--ignore-case")

(transient-define-argument counsel-popup-ag:-m ()
  :description "Skip the rest of a file after NUM matches"
  :class 'transient-option
  :shortarg "-m"
  :argument "--max-count="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-ag:-Q ()
  :description "Don't parse PATTERN as a regular expression"
  :shortarg "-Q"
  :argument "--literal")

(transient-define-argument counsel-popup-ag:-s ()
  :description "Match case sensitively"
  :shortarg "-s"
  :argument "--case-sensitive")

(transient-define-argument counsel-popup-ag:-S ()
  :description "Match case insensitively unless PATTERN contains uppercase characters"
  :shortarg "-S"
  :argument "--smart-case")

(transient-define-argument counsel-popup-ag:-v ()
  :description "Invert match"
  :shortarg "-v"
  :argument "--invert-match")

(transient-define-argument counsel-popup-ag:-w ()
  :description "Only match whole words"
  :shortarg "-w"
  :argument "--word-regexp")

(defun counsel-popup-ag-search-here (&optional string)
  "Search using `counsel-ag' in the current directory for STRING."
  (interactive)
  (counsel-popup-ag-search default-directory string))

(defun counsel-popup-ag-search (directory &optional string)
  "Search using `counsel-ag' in a given DIRECTORY for STRING."
  (interactive "DDirectory: ")
  (let* ((search-args (counsel-popup--map-arg-list (transient-args 'counsel-popup-ag)))
         (counsel-ag-base-command `(,@counsel-ag-base-command ,@search-args)))
    (counsel-ag string directory)))

(transient-define-prefix counsel-popup-ag ()
  "Search popup using `counsel-ag'."
  :man-page "ag"
  ["Output options"
   (counsel-popup-ag:-A)
   (counsel-popup-ag:-B)
   (counsel-popup-ag:-C)]
  ["Search options"
   (counsel-popup-ag:-f)
   (counsel-popup-ag:=h)
   (counsel-popup-ag:-G)
   (counsel-popup-ag:-i)
   (counsel-popup-ag:-m)
   (counsel-popup-ag:-Q)
   (counsel-popup-ag:-s)
   (counsel-popup-ag:-S)
   (counsel-popup-ag:-v)
   (counsel-popup-ag:-w)
   (counsel-popup-ag:--)]
  ["Search"
   ("s" "in current directory" counsel-popup-ag-search-here)
   ("o" "in other directory" counsel-popup-ag-search)])

(provide 'counsel-popup-ag)
;;; counsel-popup-ag.el ends here
