;;; counsel-popup.el --- Interactive version of counsel commands -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2021  Eder Elorriaga

;; Author: Eder Elorriaga <gexplorer8@gmail.com>
;; URL: https://github.com/gexplorer/counsel-popup
;; Keywords: convenience, matching, tools
;; Version: 1.0
;; Package-Requires: ((emacs "24.1"))

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

;; No comments

;;; Code:

(require 'counsel-popup-ag)
(require 'counsel-popup-rg)
(require 'counsel-popup-grep)
(require 'counsel-popup-git-grep)

(defgroup counsel-popup nil
  "Interactive versions of `counsel' commands."
  :group 'counsel
  :prefix "counsel-popup-")

(provide 'counsel-popup)
;;; counsel-popup.el ends here
