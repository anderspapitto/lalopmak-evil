
;;  Colemak Evil: A set of optimized Vim-like key bindings for Emacs.
;;  Copyright (C) 2013 Patrick Brinich-Langlois

;;  lalopmak-evil: A more geometric fork.
;;  Copyright (C) 2013

;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.


(require 'lalopmak-evil-libraries)
(require 'lalopmak-layouts)
(require 'lalopmak-jump)


;; we're using the colemak layout by default
(if (not (boundp 'lalopmak-layout-map))
    (setq lalopmak-layout-map 'colemak-to-colemak)) 

(defmacro lalopmak-evil-define-key (keymap key &rest def)
  "Defines key given the lalopmak-evil keymap, in accordance to the lalopmak-layout-map"
  `(define-key ,keymap (key-to-layout ,key lalopmak-layout-map) ,@def))


(defmacro lalopmak-evil-local-set-key (keymap key)
  "Defines local key given the lalopmak-evil keymap, in accordance to the lalopmak-layout-map"
  `(local-set-key ,keymap (key-to-layout ,key lalopmak-layout-map)))

;;;;;;;;;;;;;;;;; Bindings ;;;;;;;;;;;;;;;;;;;

;; remove all keybindings from insert-state keymap
(setcdr evil-insert-state-map nil) 
;; but [escape] should switch back to normal state
(lalopmak-evil-define-key evil-insert-state-map [escape] 'evil-normal-state) 
;; make undo more incremental (break into smaller chunks)
(setq evil-want-fine-undo t)

;; map multiple states at once (courtesy of Michael Markert;
;; http://permalink.gmane.org/gmane.emacs.vim-emulation/1674)
(defun set-in-all-evil-states (key def &optional maps)
  (unless maps
    (setq maps (list evil-normal-state-map
                     evil-visual-state-map
                     evil-insert-state-map
                     evil-emacs-state-map
		     evil-motion-state-map)))
  (while maps
    (lalopmak-evil-define-key (pop maps) key def)))


(defun set-in-all-evil-states-but-insert (key def)
  (set-in-all-evil-states key 
                          def 
                          (list evil-normal-state-map
                                evil-visual-state-map
                                evil-emacs-state-map
                                evil-motion-state-map)))

(defun set-in-all-evil-states-but-insert-and-motion (key def)
  (set-in-all-evil-states key
                          def 
                          (list evil-normal-state-map
                                evil-visual-state-map
                                evil-emacs-state-map)))

(evil-define-motion lalopmak-evil-forward-char (count)
  "Forward character, allowing you to fall to the next line"
  (evil-forward-char count 'crosslines))

(evil-define-motion lalopmak-evil-backward-char (count)
  "Backward character, allowing you to rise to the previous line"
  (evil-backward-char count 'crosslines))

;;Makes these compatible with undo-tree
(when (boundp 'undo-tree-visualizer-mode-map)
  (define-key undo-tree-visualizer-mode-map [remap lalopmak-evil-backward-char]
    'undo-tree-visualize-switch-branch-left)
  (define-key undo-tree-visualizer-mode-map [remap lalopmak-evil-forward-char]
    'undo-tree-visualize-switch-branch-right))


;;; Up/down/left/right
(set-in-all-evil-states-but-insert "u" 'evil-previous-line)
(set-in-all-evil-states-but-insert "e" 'evil-next-line)
(set-in-all-evil-states-but-insert "n" 'lalopmak-evil-backward-char)
(set-in-all-evil-states-but-insert "i" 'lalopmak-evil-forward-char)
;; (lalopmak-evil-define-key evil-operator-state-map "i" 'evil-forward-char)

;;; Turbo navigation mode
(set-in-all-evil-states-but-insert "I" '(lambda () (interactive) (evil-forward-char 5)))
(set-in-all-evil-states-but-insert "N" '(lambda () (interactive) (evil-backward-char 5)))
(set-in-all-evil-states-but-insert "E" '(lambda () (interactive) (evil-next-line 5)))
(set-in-all-evil-states-but-insert "U" '(lambda () (interactive) (evil-previous-line 5)))

;;; Beginning/end of line (home/end)
;; Use back-to-indentation instead of evil-beginning-of-line so that
;; cursor ends up at the first non-whitespace character of a line. 0
;; can be used to go to real beginning of line
(set-in-all-evil-states-but-insert "L" 'back-to-indentation)
(set-in-all-evil-states-but-insert "Y" 'evil-end-of-line)

(evil-define-motion lalopmak-evil-scroll-page-up (count)
  "Scrolls page up, centers the cursor"
  (lalopmak-evil-scroll-then-center count 'evil-scroll-page-up))

(evil-define-motion lalopmak-evil-scroll-page-down (count)
  "Scrolls page down, centers the cursor"
  (lalopmak-evil-scroll-then-center count 'evil-scroll-page-down))

;;; Page up/page down
(lalopmak-evil-define-key evil-motion-state-map "j" 'lalopmak-evil-scroll-page-up)
(lalopmak-evil-define-key evil-motion-state-map "h" 'lalopmak-evil-scroll-page-down)

;;; Page halfway up/down 
(set-in-all-evil-states-but-insert "\C-u" 'evil-scroll-up)
(set-in-all-evil-states-but-insert "\C-e" 'evil-scroll-down)


;;; Words forward/backward
(set-in-all-evil-states-but-insert "l" 'evil-backward-word-begin)
(set-in-all-evil-states-but-insert "y" 'evil-forward-word-begin)
;;; WORD forward/backward
(set-in-all-evil-states-but-insert "\C-y" 'evil-forward-WORD-begin)
(set-in-all-evil-states-but-insert "\C-l" 'evil-backward-WORD-begin)

;;; inneR text objects
;;; conflicts with find-char-backwards
;; (lalopmak-evil-define-key evil-visual-state-map "r" evil-inner-text-objects-map)
;; (lalopmak-evil-define-key evil-operator-state-map "r" evil-inner-text-objects-map)
(lalopmak-evil-define-key evil-inner-text-objects-map "y" 'evil-inner-word)
(lalopmak-evil-define-key evil-inner-text-objects-map "Y" 'evil-inner-WORD)

;; Execute command: map : to ;
(lalopmak-evil-define-key evil-motion-state-map ";" 'evil-ex);;; End of word forward/backward

;;; Folds, etc.
;; (lalopmak-evil-define-key evil-normal-state-map ",o" 'evil-open-fold)
;; (lalopmak-evil-define-key evil-normal-state-map ",c" 'evil-close-fold)
;; (lalopmak-evil-define-key evil-normal-state-map ",a" 'evil-toggle-fold)
;; (lalopmak-evil-define-key evil-normal-state-map ",r" 'evil-open-folds)
;; (lalopmak-evil-define-key evil-normal-state-map ",m" 'evil-close-folds)

;;; I'm not sure what this is
;; for virtualedit=onemore
;; set virtualedit=block,onemore


;;; Cut/copy/paste
(set-in-all-evil-states-but-insert "x" 'evil-delete-char)
(set-in-all-evil-states-but-insert "X" 'evil-delete-line)  ; delete to end of line; use dd to delete whole line
(set-in-all-evil-states-but-insert "c" 'evil-yank)
(set-in-all-evil-states-but-insert "C" 'evil-yank-line)

(set-in-all-evil-states-but-insert "V" 'evil-paste-before)
(set-in-all-evil-states-but-insert "v" 'evil-paste-after)

(set-in-all-evil-states-but-insert "\C-v" 'evil-paste-pop)




;;; Undo/redo
(lalopmak-evil-define-key evil-normal-state-map "z" 'undo)
(when (fboundp 'undo-tree-undo)
  (lalopmak-evil-define-key evil-normal-state-map "z" 'undo-tree-undo)
  (lalopmak-evil-define-key evil-normal-state-map "Z" 'undo-tree-redo))

;;; Cursor position jumplist
(set-in-all-evil-states-but-insert "(" 'evil-jump-backward)
(set-in-all-evil-states-but-insert ")" 'evil-jump-forward)


;;; Move cursor to top/bottom of screen
;; next/prior are page up/down
(set-in-all-evil-states (kbd "C-<next>") 'evil-window-bottom)
(set-in-all-evil-states (kbd "C-<prior>") 'evil-window-top)


;;; Make insert/add work also in visual line mode like in visual block mode
;; not sure what this means

;;; Visual mode
(set-in-all-evil-states-but-insert "a" 'evil-visual-char)
(set-in-all-evil-states-but-insert "A" 'evil-visual-line)
(set-in-all-evil-states-but-insert "\C-a" 'mark-whole-buffer)

;;; visual Block mode
;; Since the system clipboard is accessible by Emacs through the
;; regular paste command (v), a separate C-v mapping isn't needed.
;; (lalopmak-evil-define-key evil-motion-state-map "\C-b" 'evil-visual-block)

;;; Allow switching from visual line to visual block mode
;; not implemented

;;; Visual mode with mouse
;; not implemented
;;; Insert literal
;; not implemented

;;; GUI search
;; not implemented

;;; Redraw screen
;; not implemented

;;; Tabs
;; Who needs tabs? Use iswitchb instead. Put (iswitchb-mode 1) in your
;; .emacs and use C-x b to search for the buffer you want. C-s and C-r
;; rotate through the listed buffers

;;; New/close/save
;; these might conflict with emacs mappings


(set-in-all-evil-states-but-insert "J" 'evil-join)


;;not motion for compatiblilty with undo-tree
(set-in-all-evil-states-but-insert-and-motion "q" 'evil-replace)
(set-in-all-evil-states-but-insert-and-motion "Q" 'evil-replace-state)


(lalopmak-evil-define-key evil-motion-state-map "\C-e" 'evil-scroll-line-down)
(lalopmak-evil-define-key evil-motion-state-map "\C-f" 'evil-scroll-page-down)
(lalopmak-evil-define-key evil-motion-state-map "\C-o" 'evil-jump-backward)
(lalopmak-evil-define-key evil-motion-state-map "\C-y" 'evil-scroll-line-up)

;;; Scroll in place
(lalopmak-evil-define-key evil-motion-state-map (kbd "C-<up>") 'evil-scroll-line-up)
(lalopmak-evil-define-key evil-motion-state-map (kbd "C-<down>") 'evil-scroll-line-down)

;;; Live line reordering
;; not implemented

;;; Restore mappings
;;; Free mappings: ,/+/H

;;; Macros
;; (lalopmak-evil-define-key evil-normal-state-map "Q" '(lambda ()
;; 					 (interactive)
;; 					 (evil-execute-macro 1 last-kbd-macro)))

;; (cond (window-system  ; ensure not running in a terminal
;;        (lalopmak-evil-local-set-key (kbd "<return>") 'newline)
;;        (lalopmak-evil-local-set-key "\C-m" 'evil-record-macro)))
(lalopmak-evil-define-key evil-normal-state-map "'" 'evil-execute-macro)
(lalopmak-evil-define-key evil-normal-state-map "m" 'evil-record-macro)
;; (lalopmak-evil-define-key evil-normal-state-map "\"" 'evil-execute-macro)


(define-key evil-normal-state-map "M" 'evil-set-marker)

(define-key evil-motion-state-map (kbd "C-'") 'evil-goto-mark-line)
;;; Duplicate line
;; not implemented
;; Use "CV" instead

;;; Misc overridden keys must be prefixed with g
;; not implemented

;;; Search
(lalopmak-evil-define-key evil-motion-state-map "k" 'evil-search-next)
(lalopmak-evil-define-key evil-motion-state-map "K" 'evil-search-previous)

;;; Folding
;; (lalopmak-evil-define-key evil-normal-state-map "zo" 'evil-open-fold)
;; (lalopmak-evil-define-key evil-normal-state-map "zc" 'evil-close-fold)
;; (lalopmak-evil-define-key evil-normal-state-map "za" 'evil-toggle-fold)
;; (lalopmak-evil-define-key evil-normal-state-map "zr" 'evil-open-folds)
;; (lalopmak-evil-define-key evil-normal-state-map "zm" 'evil-close-folds)

;;; Make the space, return, and backspace keys work in normal mode
;; Backspace in normal mode doesn't work in the terminal.
(lalopmak-evil-define-key evil-motion-state-map " " (lambda () (interactive) (insert " ")))
(lalopmak-evil-define-key evil-motion-state-map (kbd "RET") (lambda () (interactive) (newline)))
(lalopmak-evil-define-key evil-motion-state-map (kbd "<backspace>") 'delete-backward-char)

;;; Visual line navigation
;; In normal mode, use "ge" and "gu" when lines wrap.
(set-in-all-evil-states-but-insert "ge" 'evil-next-visual-line)
(set-in-all-evil-states-but-insert "gu" 'evil-previous-visual-line)

;;; Window handling
;; C-w (not C-r as in Shai's mappings) prefixes window commands

(lalopmak-evil-define-key evil-window-map "n" 'evil-window-left)
(lalopmak-evil-define-key evil-window-map "N" 'evil-window-move-far-left)
(lalopmak-evil-define-key evil-window-map "e" 'evil-window-down)
(lalopmak-evil-define-key evil-window-map "E" 'evil-window-move-very-bottom)
(lalopmak-evil-define-key evil-window-map "u" 'evil-window-up)
(lalopmak-evil-define-key evil-window-map "U" 'evil-window-move-very-top)
(lalopmak-evil-define-key evil-window-map "i" 'evil-window-right)
(lalopmak-evil-define-key evil-window-map "I" 'evil-window-move-far-right)
(lalopmak-evil-define-key evil-window-map "k" 'evil-window-new)


(set-in-all-evil-states-but-insert (kbd "\\")  'evil-indent)


;; Insert
(set-in-all-evil-states-but-insert "r" 'evil-insert)
(set-in-all-evil-states-but-insert "R" 'evil-insert-line)

;;Append
(set-in-all-evil-states-but-insert "s" 'evil-append)
(set-in-all-evil-states-but-insert "S" 'evil-append-line)

;;Change
(set-in-all-evil-states-but-insert "\C-p" 'evil-change-line)
(set-in-all-evil-states-but-insert "w" 'evil-change)
(set-in-all-evil-states-but-insert "p" 'evil-substitute)   ;tentative assignment
(set-in-all-evil-states-but-insert "W" 'evil-change-whole-line)


;;Ace jump
(set-in-all-evil-states-but-insert "f" 'lalopmak-evil-ace-jump-char-mode)
(set-in-all-evil-states-but-insert "F" 'lalopmak-evil-ace-jump-char-to-mode)
(set-in-all-evil-states-but-insert "t" 'evil-ace-jump-char-mode)
(set-in-all-evil-states-but-insert "T" 'evil-ace-jump-char-to-mode)
(set-in-all-evil-states "\C-f" 'evil-ace-jump-char-mode)

;;Line jump
(set-in-all-evil-states "\M-f" 'evil-ace-jump-line-mode)
(set-in-all-evil-states-but-insert "T" 'evil-ace-jump-line-mode) ;temporary assignment

;switch to buffer
(lalopmak-evil-define-key evil-motion-state-map "b" 'switch-to-buffer)
(lalopmak-evil-define-key evil-motion-state-map "B" 'find-file)

(lalopmak-evil-define-key evil-motion-state-map "\M-a" 'evil-visual-block)

;;;;;;;;;;;;PASTING;;;;;;;;;;;;;;;;;;
(evil-define-motion lalopmak-evil-paste-below (count)
  "Pastes in the line below."
  (evil-open-below 1) 
  ;; (newline count) ;;TODO count indicates number of lines until the paste
  (evil-paste-after 1))

(evil-define-motion lalopmak-evil-paste-below-then-normal (count)
  "Pastes in the line below then normal mode."
  (lalopmak-evil-paste-below count)
  (evil-normal-state))

(evil-define-motion lalopmak-evil-paste-above (count)
  "Pastes in the line above."
  (evil-open-above 1) 
  ;; (newline count) ;;TODO count indicates number of lines until the paste
  (evil-paste-after 1))

(evil-define-motion lalopmak-evil-paste-above-then-normal (count)
  "Pastes in the line above then normal mode."
  (lalopmak-evil-paste-above count)
  (evil-normal-state))

(evil-define-motion lalopmak-evil-paste-at-bol (count)
  "Pastes at beginning of line."
  (back-to-indentation) 
  (evil-paste-before 1))

(evil-define-motion lalopmak-evil-paste-at-eol (count)
  "Pastes at end of line."
  (evil-end-of-line) 
  (evil-paste-after 1))

(evil-define-motion lalopmak-evil-goto-line-if-count-else-open-below (count)
  "evil-open-below unless preceded by number, in which case
go to that line."
  (if count
      (evil-goto-line count)
    (evil-open-below 1)))

;;o to open in line above/below, or [number]o to go to line [number]
(set-in-all-evil-states-but-insert "o" 'lalopmak-evil-goto-line-if-count-else-open-below)
(set-in-all-evil-states-but-insert "O" 'evil-open-above)

;;M-[direction] to paste in that direction
(set-in-all-evil-states-but-insert "\M-u" 'lalopmak-evil-paste-above-then-normal)
(set-in-all-evil-states-but-insert "\M-e" 'lalopmak-evil-paste-below-then-normal)
(lalopmak-evil-define-key evil-insert-state-map "\M-u" 'lalopmak-evil-paste-above) 
(lalopmak-evil-define-key evil-insert-state-map "\M-e" 'lalopmak-evil-paste-below)
(set-in-all-evil-states "\M-n" 'lalopmak-evil-paste-at-bol)
(set-in-all-evil-states "\M-i" 'lalopmak-evil-paste-at-eol)


(defun lalopmak-evil-write (beg end &optional type filename bang)
  (if  (and (boundp 'edit-server-edit-mode) edit-server-edit-mode)  
      (edit-server-save) 
    (evil-write beg end type filename bang)))

;; (defadvice evil-write (around check-edit-server 
;;                               (beg end &optional type filename bang))
;;   (if (edit-server-edit-mode-running) 
;;       (edit-server-save) 
;;     ad-do-it))

;;;;;;;;;;;;;;;;;; Custom : commands ;;;;;;;;;;;;;;;;;;;;;;;

;; Makes ; an alias for :

(set-in-all-evil-states-but-insert ";" 'evil-ex)

;;hooks for hints
(evil-ex-define-cmd "hints" 'lalopmak-evil-hints)
(evil-ex-define-cmd "ars" "hints")

;;hooks for quitting/saving commands
(evil-ex-define-cmd "w[rite]" 'evil-write)

;;git
(evil-ex-define-cmd "git" 'magit-status)

;;linum relative toggle
(evil-ex-define-cmd "relative" 'linum-relative-toggle)
(evil-ex-define-cmd "ccmode" 'centered-cursor-mode)


;;comment
(evil-ex-define-cmd "comment" 'comment-or-uncomment-region)
(evil-ex-define-cmd "c" "comment")


;;M-:
(evil-ex-define-cmd "eval" 'eval-expression)
(evil-ex-define-cmd "ev" "eval")
(evil-ex-define-cmd "ielm" 'ielm-window)
(evil-ex-define-cmd "interactive-eval" "ielm")

;;Terminal
(evil-ex-define-cmd "terminal" 'sole-terminal-window)
(evil-ex-define-cmd "newterminal" 'new-terminal-window)


;;C-h k
(evil-ex-define-cmd "describe-key" 'describe-key)
(evil-ex-define-cmd "key" "describe-key")

;;C-h f
(evil-ex-define-cmd "describe-function" 'describe-function)
(evil-ex-define-cmd "function" "describe-function")
(evil-ex-define-cmd "fun" "describe-function")

;;C-h v

(evil-ex-define-cmd "describe-variable" 'describe-variable)
(evil-ex-define-cmd "variable" "describe-variable")

;;M-x speck-mode (spell checking)

(evil-ex-define-cmd "spell" 'speck-mode)

;;Ya-snippets

(defun evil-snippet (name)
  (interactive "sSnippet shortcut:")
  (evil-insert 1)
  (insert (concat " " name))
  (yas-expand))

(evil-ex-define-cmd "snippet" 'evil-snippet)

;;Frame sizes

;; (evil-ex-define-cmd "fit" 'fit-frame-to-buffer)

(evil-ex-define-cmd "small" 'set-frame-to-default-size)
(evil-ex-define-cmd "large" 'maximize-frame-except-some-width)
(evil-ex-define-cmd "fullscreen" 'maximize-frame)

(evil-ex-define-cmd "tall" 'make-frame-tall)
(evil-ex-define-cmd "wide" 'make-frame-wide)
(evil-ex-define-cmd "corner" 'frame-to-top-left-corner)


;; (ad-activate-all)  ;activates all advice

;;FRAGILE
;;Redefines visual updates so as to update the primary, rather than the clipboard, with the selection
;;This also allows you to select a region, copy from outside, then paste into the region
(defun evil-visual-update-x-selection (&optional buffer)
  "Update the X selection with the current visual region."
  (let ((buf (or buffer (current-buffer))))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (when (and (evil-visual-state-p)
                   (fboundp 'x-select-text)
                   (or (not (boundp 'ns-initialized))
                       (with-no-warnings ns-initialized))
                   (not (eq evil-visual-selection 'block)))
          (x-set-selection 'PRIMARY (buffer-substring-no-properties
                                     evil-visual-beginning
                                     evil-visual-end))
          (setq x-last-selected-text-primary ))))))


;;Experiment: swaps o and :
;; (set-in-all-evil-states-but-insert ";" 'lalopmak-evil-goto-line-if-count-else-open-below)
;; (set-in-all-evil-states-but-insert ":" 'evil-open-above)
;; (set-in-all-evil-states-but-insert "o" 'evil-ex)
;; (set-in-all-evil-states-but-insert "O" 'evil-ex)

(provide 'lalopmak-evil)


