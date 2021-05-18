;;; counsel-popup-core.el --- The core libraries for counsel-popup -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Eder Elorriaga

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

;; The core libraries for counsel-popup.

;;; Code:

(require 'transient)

(defun counsel-popup--map-args (args)
  "Convert ARGS to a string of args.
For each arg:
- If string, then return it unmodified.
- If list '(prefix value1 value2...) return all values prepend with the prefix."
  (mapconcat
   (lambda (arg)
     (if (listp arg)
         (let ((prefix (car arg))
               (values (cdr arg)))
           (mapconcat (lambda (value) (concat prefix value)) values " "))
       arg))
   args
   " "))

(defun counsel-popup--map-arg-list (args)
  "Convert ARGS to a list of args.
For each arg:
- If string, then return it unmodified.
- If list '(prefix value1 value2...) return all values prepend with the prefix."
  (seq-reduce
   (lambda (acc arg)
     (if (listp arg)
         (let ((prefix (car arg))
               (values (cdr arg)))
           `(,@acc ,@(mapcar (lambda (value) (concat prefix value)) values)))
       `(,@acc ,arg))
     )
   args
   '()))

(defclass counsel-popup-file-types (transient-infix) ()
  "Class used for the file types argument.
All remaining arguments are treated as file types.
They become the value of this argument.")

(cl-defmethod transient-format-value ((obj counsel-popup-file-types))
  "Format OBJ's value for display and return the result."
  (let ((argument (oref obj argument)))
    (if-let ((values (oref obj value)))
        (propertize (concat argument " "
                            (mapconcat (lambda (value) (format "%S" value)) values " "))
                    'face 'transient-argument)
      (propertize argument 'face 'transient-inactive-argument))))

(cl-defmethod transient-init-value ((obj counsel-popup-file-types))
  "Set the initial value of the object OBJ."
  (with-slots (argument) obj
    (oset obj value (cdr (assoc argument (oref transient--prefix value))))))

(cl-defmethod transient-infix-set ((obj counsel-popup-file-types) value)
  "Set the value of infix object OBJ to value."
  (oset obj value value))

(cl-defmethod transient-infix-value ((obj counsel-popup-file-types))
  "Return (cons ARGUMENT VALUE) or nil.

ARGUMENT and VALUE are the values of the respective slots of OBJ.
If VALUE is nil, then return nil.  VALUE may be the empty string,
which is not the same as nil."
  (with-slots (value argument) obj
    (when value
      (cons argument value))))

(provide 'counsel-popup-core)
;;; counsel-popup-core.el ends here
