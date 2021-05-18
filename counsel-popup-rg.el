;;; counsel-popup-rg.el --- Interactive search with counsel-rg -*- lexical-binding: t; -*-

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

;; Just call the interactive function `counsel-popup-rg' and use the
;; popup to configure the search.

;;; Code:

(require 'counsel)
(require 'counsel-popup-core)

(defcustom counsel-popup-rg-file-type-list
  '("agda" "aidl" "amake" "asciidoc" "asm" "asp" "ats" "avro" "awk" "bazel" "bitbake" "buildstream"
    "bzip2" "c" "cabal" "cbor" "ceylon" "clojure" "cmake" "coffeescript" "config" "cpp" "creole"
    "crystal" "cs" "csharp" "cshtml" "css" "csv" "cython" "d" "dart" "dhall" "docker" "elisp" "elixir"
    "elm" "erlang" "fidl" "fish" "fortran" "fsharp" "gn" "go" "groovy" "gzip" "h" "haskell" "hbs" "hs"
    "html" "idris" "java" "jinja" "jl" "js" "json" "jsonl" "julia" "jupyter" "kotlin" "less" "license"
    "lisp" "log" "lua" "lz4" "lzma" "m4" "make" "mako" "man" "markdown" "matlab" "md" "mk" "ml"
    "msbuild" "nim" "nix" "objc" "objcpp" "ocaml" "org" "pascal" "pdf" "perl" "php" "pod" "postscript"
    "protobuf" "ps" "puppet" "purs" "py" "qmake" "r" "rdoc" "readme" "rst" "ruby" "rust" "sass" "scala"
    "sh" "smarty" "sml" "soy" "spark" "sql" "stylus" "sv" "svg" "swift" "swig" "systemd" "taskpaper"
    "tcl" "tex" "textile" "tf" "thrift" "toml" "ts" "twig" "txt" "vala" "vb" "verilog" "vhdl" "vim"
    "vimscript" "webidl" "wiki" "xml" "xz" "yacc" "yaml" "zsh")
  "List of supported file types for `counsel-popup-rg'."
  :group 'counsel-popup
  :type '(repeat string))

(defun counsel-popup-rg-read-pattern (prompt initial-input history)
  "Read a pattern from the minibuffer, prompting with string PROMPT.

If non-nil, second arg INITIAL-INPUT is a string to insert before reading.
The third arg HISTORY, if non-nil, specifies a history."
  (read-string prompt initial-input history))

(transient-define-argument counsel-popup-rg:-- ()
  "Restrict the search to certain types of files."
  :description "Limit to file types"
  :class 'counsel-popup-file-types
  :key "--"
  :argument "--type="
  :prompt "Limit to file type(s): "
  :multi-value t
  :choices counsel-popup-rg-file-type-list)

(transient-define-argument counsel-popup-rg:-A ()
  :description "Show NUM lines after each match"
  :class 'transient-option
  :shortarg "-A"
  :argument "--after-context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-rg:-B ()
  :description "Show NUM lines before each match"
  :class 'transient-option
  :shortarg "-B"
  :argument "--before-context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-rg:-C ()
  :description "Show NUM lines before and after each match"
  :class 'transient-option
  :shortarg "-C"
  :argument "--context="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-rg:=h ()
  :description "Search hidden files and directories"
  :shortarg "=h"
  :argument "--hidden")

(transient-define-argument counsel-popup-rg:-L ()
  :description "Follow symlinks"
  :shortarg "-L"
  :argument "--follow")

(transient-define-argument counsel-popup-rg:-i ()
  :description "Match case insensitively"
  :shortarg "-i"
  :argument "--ignore-case")

(transient-define-argument counsel-popup-rg:-m ()
  :description "Limit the number of matching lines per file searched to NUM"
  :class 'transient-option
  :shortarg "-m"
  :argument "--max-count="
  :reader 'transient-read-number-N+)

(transient-define-argument counsel-popup-rg:-F ()
  :description "Treat the pattern as a literal string instead of a regular expression"
  :shortarg "-F"
  :argument "--fixed-strings")

(transient-define-argument counsel-popup-rg:-s ()
  :description "Search case sensitively"
  :shortarg "-s"
  :argument "--case-sensitive")

(transient-define-argument counsel-popup-rg:-S ()
  :description "Searches case insensitively if the pattern is all lowercase"
  :shortarg "-S"
  :argument "--smart-case")

(transient-define-argument counsel-popup-rg:-v ()
  :description "Invert matching"
  :shortarg "-v"
  :argument "--invert-match")

(transient-define-argument counsel-popup-rg:-w ()
  :description "Only show matches surrounded by word boundaries"
  :shortarg "-w"
  :argument "--word-regexp")

(defun counsel-popup-rg-search-project (&optional string)
  "Search using `counsel-rg' in the current project for STRING."
  (interactive)
  (counsel-popup-rg-search nil string))

(defun counsel-popup-rg-search (directory &optional string)
  "Search using `counsel-rg' in a given DIRECTORY for STRING."
  (interactive "DDirectory: ")
  (let* ((search-args (counsel-popup--map-arg-list (transient-args 'counsel-popup-rg)))
         (counsel-rg-base-command `(,@counsel-rg-base-command ,@search-args)))
    (counsel-rg string directory)))

(transient-define-prefix counsel-popup-rg ()
  "Search popup using `counsel-rg'."
  :man-page "rg"
  ["Output options"
   (counsel-popup-rg:-A)
   (counsel-popup-rg:-B)
   (counsel-popup-rg:-C)]
  ["Search options"
   (counsel-popup-rg:-L)
   (counsel-popup-rg:=h)
   (counsel-popup-rg:-i)
   (counsel-popup-rg:-m)
   (counsel-popup-rg:-F)
   (counsel-popup-rg:-s)
   (counsel-popup-rg:-S)
   (counsel-popup-rg:-v)
   (counsel-popup-rg:-w)
   (counsel-popup-rg:--)]
  ["Search"
   ("s" "in project" counsel-popup-rg-search-project)
   ("o" "in other directory" counsel-popup-rg-search)])

(provide 'counsel-popup-rg)
;;; counsel-popup-rg.el ends here
