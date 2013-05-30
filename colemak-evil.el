;;; License
    
;; Colemak Evil: A set of optimized Vim-like key bindings for Emacs.
;; Copyright (C) 2013 Patrick Brinich-Langlois
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; For the full text of the GNU General Public License, see
;; http://www.gnu.org/licenses/gpl.html 

;; remove all keybindings from insert-state keymap
(setcdr evil-insert-state-map nil) 
;; but [escape] should switch back to normal state
(define-key evil-insert-state-map [escape] 'evil-normal-state) 
;; make undo more incremental (break into smaller chunks)
(setq evil-want-fine-undo t)

;; To enter normal mode: Use <Esc> or define your own key combination
;;  using Key Chord (http://www.emacswiki.org/emacs/key-chord.el).
;;  "hn" is the only home-row combination that I know of that is
;;  relatively uncommon in English: (key-chord-define-global "hn"
;;  'evil-normal-state)

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
    (define-key (pop maps) key def)))


(defun set-in-all-evil-states-but-insert (key def)
  (set-in-all-evil-states key def (list evil-normal-state-map
					evil-visual-state-map
					evil-emacs-state-map
					evil-motion-state-map)))


(defun set-in-all-evil-states-but-insert-and-motion (key def)
  (set-in-all-evil-states key def (list evil-normal-state-map
					evil-visual-state-map
					evil-emacs-state-map)))

;;; No insert-state alt-navigation remappings (they would clobber
;;; Emacs shortcuts, and Emacs has its own navigation commands that 
;;; you can use

;;; Up/down/left/right
(set-in-all-evil-states-but-insert "u" 'evil-previous-line)
(set-in-all-evil-states-but-insert "e" 'evil-next-line)
(set-in-all-evil-states-but-insert "n" 'evil-backward-char)
(set-in-all-evil-states-but-insert "i" 'evil-forward-char)
(define-key evil-operator-state-map "i" 'evil-forward-char)

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

;;; Page up/page down
(define-key evil-motion-state-map (kbd "j") 'evil-scroll-page-up)
(define-key evil-motion-state-map (kbd "h") 'evil-scroll-page-down)

;;; Page halfway up/down 
(set-in-all-evil-states-but-insert "\C-u" 'evil-scroll-up)
(set-in-all-evil-states-but-insert "\C-e" 'evil-scroll-down)


;;; Words forward/backward
(set-in-all-evil-states-but-insert "l" 'evil-backward-word-begin)
(set-in-all-evil-states-but-insert "y" 'evil-forward-word-begin)
;;; WORD forward/backward
(set-in-all-evil-states-but-insert (kbd "C-y") 'evil-forward-WORD-begin)
(set-in-all-evil-states-but-insert (kbd "C-l") 'evil-backward-WORD-begin)

;;; inneR text objects
;;; conflicts with find-char-backwards
;; (define-key evil-visual-state-map "r" evil-inner-text-objects-map)
;; (define-key evil-operator-state-map "r" evil-inner-text-objects-map)
(define-key evil-inner-text-objects-map "y" 'evil-inner-word)
(define-key evil-inner-text-objects-map "Y" 'evil-inner-WORD)

;; Execute command: map : to ;
(define-key evil-motion-state-map ";" 'evil-ex);;; End of word forward/backward

;;; Folds, etc.
;; (define-key evil-normal-state-map ",o" 'evil-open-fold)
;; (define-key evil-normal-state-map ",c" 'evil-close-fold)
;; (define-key evil-normal-state-map ",a" 'evil-toggle-fold)
;; (define-key evil-normal-state-map ",r" 'evil-open-folds)
;; (define-key evil-normal-state-map ",m" 'evil-close-folds)

;;; I'm not sure what this is
;; for virtualedit=onemore
;; set virtualedit=block,onemore

;;; Cut/copy/paste
(set-in-all-evil-states-but-insert "x" 'evil-delete-char)
(set-in-all-evil-states-but-insert "X" 'evil-delete-line)  ; delete to end of line; use dd to delete whole line
(set-in-all-evil-states-but-insert "c" 'evil-yank)
(set-in-all-evil-states-but-insert "C" 'evil-yank-line)
(set-in-all-evil-states-but-insert "v" 'evil-paste-before)
(set-in-all-evil-states-but-insert "V" 'evil-paste-after)

;;; Undo/redo
(define-key evil-normal-state-map "z" 'undo)
(when (fboundp 'undo-tree-undo)
  (define-key evil-normal-state-map "z" 'undo-tree-undo)
  (define-key evil-normal-state-map "Z" 'undo-tree-redo))

;;; Break undo chain
;; not sure what this is

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
;; (define-key evil-motion-state-map "\C-b" 'evil-visual-block)

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


(define-key evil-motion-state-map (kbd "C-e") 'evil-scroll-line-down)
(define-key evil-motion-state-map (kbd "C-f") 'evil-scroll-page-down)
(define-key evil-motion-state-map (kbd "C-o") 'evil-jump-backward)
(define-key evil-motion-state-map (kbd "C-y") 'evil-scroll-line-up)

;;; Scroll in place
(define-key evil-motion-state-map (kbd "C-<up>") 'evil-scroll-line-up)
(define-key evil-motion-state-map (kbd "C-<down>") 'evil-scroll-line-down)

;;; Live line reordering
;; not implemented

;;; Restore mappings
;;; Free mappings: ,/+/H

;;; Macros
(define-key evil-normal-state-map "Q" '(lambda ()
					 (interactive)
					 (evil-execute-macro 1 last-kbd-macro)))

;;; Duplicate line
;; not implemented
;; Use "CV" instead

;;; Misc overridden keys must be prefixed with g
;; not implemented

;;; Search
(define-key evil-motion-state-map "k" 'evil-search-next)
(define-key evil-motion-state-map "K" 'evil-search-previous)

;;; Folding
;; (define-key evil-normal-state-map "zo" 'evil-open-fold)
;; (define-key evil-normal-state-map "zc" 'evil-close-fold)
;; (define-key evil-normal-state-map "za" 'evil-toggle-fold)
;; (define-key evil-normal-state-map "zr" 'evil-open-folds)
;; (define-key evil-normal-state-map "zm" 'evil-close-folds)

;;; Make the space, return, and backspace keys work in normal mode
;; Backspace in normal mode doesn't work in the terminal.
(define-key evil-motion-state-map " " (lambda () (interactive) (insert " ")))
(define-key evil-motion-state-map (kbd "RET") (lambda () (interactive) (newline)))
(define-key evil-motion-state-map (kbd "<backspace>") 'delete-backward-char)

;;; Visual line navigation
;; In normal mode, use "ge" and "gu" when lines wrap.
(set-in-all-evil-states-but-insert "ge" 'evil-next-visual-line)
(set-in-all-evil-states-but-insert "gu" 'evil-previous-visual-line)

;;; Window handling
;; C-w (not C-r as in Shai's mappings) prefixes window commands
(define-key evil-window-map "n" 'evil-window-left)
(define-key evil-window-map "N" 'evil-window-move-far-left)
(define-key evil-window-map "e" 'evil-window-down)
(define-key evil-window-map "E" 'evil-window-move-very-bottom)
(define-key evil-window-map "u" 'evil-window-up)
(define-key evil-window-map "U" 'evil-window-move-very-top)
(define-key evil-window-map "i" 'evil-window-right)
(define-key evil-window-map "I" 'evil-window-move-far-right)
(define-key evil-window-map "k" 'evil-window-new)



(define-key evil-normal-state-map (kbd "TAB")  'evil-indent)





;; Radical version: insert and change at wf

;;Insert
(set-in-all-evil-states-but-insert "w" 'evil-insert)
(set-in-all-evil-states-but-insert "W" 'evil-insert-line)

;;Change
(set-in-all-evil-states-but-insert "f" 'evil-change)
(set-in-all-evil-states-but-insert "F" 'evil-change-line)

;;Find char
(set-in-all-evil-states-but-insert "r" 'evil-find-char-backward)
(set-in-all-evil-states-but-insert "s" 'evil-find-char)
(set-in-all-evil-states-but-insert "S" 'evil-find-char-to)
(set-in-all-evil-states-but-insert "R" 'evil-find-char-to-backward)


;; Conservative version: insert and change at rs

;; ;; Insert
;; (set-in-all-evil-states-but-insert "r" 'evil-insert)
;; (set-in-all-evil-states-but-insert "R" 'evil-insert-line)

;; ;;Change
;; (set-in-all-evil-states-but-insert "s" 'evil-change)
;; (set-in-all-evil-states-but-insert "S" 'evil-change-line)

;; ;;Find char
;; (set-in-all-evil-states-but-insert "w" 'evil-find-char-backward)
;; (set-in-all-evil-states-but-insert "f" 'evil-find-char)
;; (set-in-all-evil-states-but-insert "W" 'evil-find-char-to)
;; (set-in-all-evil-states-but-insert "F" 'evil-find-char-to-backward)



;;Append
(set-in-all-evil-states-but-insert "p" 'evil-append)
(set-in-all-evil-states-but-insert "P" 'evil-append-line)

(set-in-all-evil-states-but-insert "T" 'evil-repeat-find-char-reverse)
(set-in-all-evil-states-but-insert "t" 'evil-repeat-find-char)







;; (set-in-all-evil-states-but-insert-and-motion "f" 'delete-backward-char)
;; (set-in-all-evil-states-but-insert "F" 'delete-forward-char)

(define-key evil-motion-state-map "b" 'switch-to-buffer)
(define-key evil-motion-state-map "B" 'find-file)

(define-key evil-motion-state-map "\M-a" 'evil-visual-block)

;;;;;;;;;;;;PASTING;;;;;;;;;;;;;;;;;;
(evil-define-motion colemak-evil-paste-below (count)
  "Pastes in the line below."
  (evil-open-below 1) 
  ;; (newline count) ;;TODO count indicates number of lines until the paste
  (evil-paste-after 1))

(evil-define-motion colemak-evil-paste-below-then-normal (count)
  "Pastes in the line below then normal mode."
  (colemak-evil-paste-below count)
  (evil-normal-state))

(evil-define-motion colemak-evil-paste-above (count)
  "Pastes in the line above."
  (evil-open-above 1) 
  ;; (newline count) ;;TODO count indicates number of lines until the paste
  (evil-paste-after 1))

(evil-define-motion colemak-evil-paste-above-then-normal (count)
  "Pastes in the line above then normal mode."
  (colemak-evil-paste-above count)
  (evil-normal-state))

(evil-define-motion colemak-evil-paste-at-bol (count)
  "Pastes at beginning of line."
  (back-to-indentation) 
  (evil-paste-before 1))

(evil-define-motion colemak-evil-paste-at-eol (count)
  "Pastes at end of line."
  (evil-end-of-line) 
  (evil-paste-after 1))

(evil-define-motion colemak-evil-goto-line-if-count-else-open-below (count)
  "evil-open-below unless preceded by number, in which case
go to that line."
  (if count
      (evil-goto-line count)
    (evil-open-below 1)))

;o to open in line above/below, or [number]o to go to line [number]
(set-in-all-evil-states-but-insert "o" 'colemak-evil-goto-line-if-count-else-open-below)
(set-in-all-evil-states-but-insert "O" 'evil-open-above)

;M-[direction] to paste in that direction; keeps in insert mode iff already in that
(set-in-all-evil-states-but-insert "\M-u" 'colemak-evil-paste-above-then-normal)
(set-in-all-evil-states-but-insert "\M-e" 'colemak-evil-paste-below-then-normal)
(define-key evil-insert-state-map "\M-u" 'colemak-evil-paste-above) 
(define-key evil-insert-state-map "\M-e" 'colemak-evil-paste-below)

(set-in-all-evil-states "\M-n" 'colemak-evil-paste-at-bol)
(set-in-all-evil-states "\M-i" 'colemak-evil-paste-at-eol)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;TODO make caps paste from kill ring search above/below

;;;;Experiment: generalize the paste-above/paste-below functions as macros
;; (defmacro colemak-evil-do-body ( body)
;;   (when body
;;     (car body)
;;     (colemak-evil-do-body (cdr body))))

;; (defmacro colemak-evil-do-interactively-then-normal (&rest body)
;;   `(lambda (count)
;;      (interactive)
;;      (colemak-evil-do-body ,body)
;;      (evil-normal-state)))
  

;; (set-in-all-evil-states-but-insert "o" 'evil-open-below)
;; (set-in-all-evil-states-but-insert "O" 'evil-open-above)
;; (define-key evil-motion-state-map "\C-o" (colemak-evil-do-interactively-then-normal (evil-open-below 1) (evil-paste-after 1) ))
;; (define-key evil-motion-state-map "\C-O" (colemak-evil-do-interactively-then-normal (evil-open-above 1) (evil-paste-after 1) ))




;; ;;Experiment: swap o and ;
;; (set-in-all-evil-states-but-insert ";" 'evil-open-below)
;; (set-in-all-evil-states-but-insert ":" 'evil-open-above)
;; (define-key evil-motion-state-map "\M-;" 'colemak-evil-paste-below)
;; (define-key evil-motion-state-map "\M-:" 'colemak-evil-paste-above)
;; ;;accounting for the other usages of o
;; (define-key evil-window-map ";" 'delete-other-windows)
;; (define-key evil-visual-state-map ";" 'exchange-point-and-mark)
;; (define-key evil-visual-state-map ":" 'evil-visual-exchange-corners)
;; (define-key evil-normal-state-map ";" 'evil-open-below)
;; (define-key evil-normal-state-map ":" 'evil-open-above)
;; ;;deleting those other usages of o
;; (define-key evil-window-map "o" (lambda (&optional argz)))
;; (define-key evil-visual-state-map "o" (lambda (&optional argz)))
;; (define-key evil-visual-state-map "O" (lambda (&optional argz)))
;; (define-key evil-normal-state-map "o" (lambda (&optional argz)))
;; (define-key evil-normal-state-map "O" (lambda (&optional argz)))

;; Custom : commands
;; Makes ; an alias for :
(define-key evil-motion-state-map ";" 'evil-ex-read-command)
(evil-ex-define-cmd "git" 'magit-status)
(evil-ex-define-cmd "comment" 'comment-or-uncomment-region)
(evil-ex-define-cmd "c" "comment")

(defun colemak-evil-hints ()
  "Hello World and you can call it via M-x hello."
  (interactive)
  (message "Hello World!"))

