;;;    --- Prelude ---
;;; This init file will provide you with several
;;; capabilities. It is broken into sections, delimited by
;;;    ---Section---
;;; and
;;;    ---End Section---
;;; .
;;; Sections will contain configuration subsections, delimited by
;;;    ;;; <subsection-name>
;;;    ;;; Docs: <link to documentation>
;;;    ;;;
;;;    ;;; Explanatory commentary
;;; and
;;;    ;;; End <subsection-name>
;;; .
;;;
;;; I've also generated comments using chat-gpt that follow each line,
;;; so that you can have a clearer understanding without having to use
;;;    * `M-x describe-variable`
;;;    * `M-x describe-function`
;;; and others to understand what each line does here. I hope it will
;;; assist you in learning how to configure things and use elisp as
;;; you begin your emacs journey.
;;;    --- End Prelude ---

;;;    --- Package Management Initialization ---

;;; straight.el bootstrap
;;; Docs: https://github.com/radian-software/straight.el
;;;
;;; Straight.el is a package manager that can install from git repos,
;;; urls, and melpa/elpa/gnu. It is very flexible, and will allow you
;;; to access the most packages possible.
;; Declare the variable `bootstrap-version` without initializing it.
(defvar bootstrap-version)

;; Use a `let` binding to create local variables for this scope.
(let ((bootstrap-file  ;; Define `bootstrap-file` as a local variable.
       (expand-file-name  ;; Expand the file path to an absolute path.
        "straight/repos/straight.el/bootstrap.el"  ;; The relative path to the bootstrap file.
        (or (bound-and-true-p straight-base-dir)  ;; Use `straight-base-dir` if it's bound and true.
            user-emacs-directory)))  ;; Otherwise, use `user-emacs-directory`.
      (bootstrap-version 7))  ;; Set `bootstrap-version` to 7 within this local scope.

  ;; Check if the bootstrap file does not exist.
  (unless (file-exists-p bootstrap-file)
    ;; If the file does not exist, download and evaluate the install script.
    (with-current-buffer
        (url-retrieve-synchronously  ;; Synchronously retrieve the URL's content.
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"  ;; The URL to the install script.
         'silent 'inhibit-cookies)  ;; Suppress output and don't store cookies.
      (goto-char (point-max))  ;; Move to the end of the buffer (where the retrieved content is).
      (eval-print-last-sexp)))  ;; Evaluate the last S-expression in the buffer.

  ;; Load the bootstrap file. The third argument 'nomessage' suppresses the loading message.
  (load bootstrap-file nil 'nomessage))
;;; end straight.el bootstrap

;;; use-package installation
;;; Docs: https://github.com/radian-software/straight.el?tab=readme-ov-file#integration-with-use-package
;;;
;;; `use-package` makes it easier to declaritively manage your
;;; packages within your init file. Installing it correctly can be a
;;; bit of a chore. Luckily, we've bootstrapped the installation with
;;; straight, which will allow you to use it out of the box.
;; Use the `straight-use-package` function to install and configure the 'use-package' package.
(straight-use-package 'use-package)
;;; end use-package installation
;;;    --- End Package Management Initialization ---

;;;    --- Global Initialization ---

;;; set global variables
;;; Docs: NA, see comments
;;;
;; Set multiple variables with `setq`.
(setq 
      ;; Always defer loading packages when using `use-package`.
      use-package-always-defer t

      ;; Always ensure that packages are installed when using `use-package`.
      use-package-always-ensure t

      ;; Set the backup directory to `temporary-file-directory` for all files.
      backup-directory-alist `((".*" . ,temporary-file-directory))

      ;; Set the auto-save file name transformations to store them in `temporary-file-directory`.
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
;;; end set global variables
;;;    --- End Global Initialization ---

;;;    --- Package Selection and Configuration ---
;;; exec-path-from-shell
;;; Docs: https://github.com/purcell/exec-path-from-shell
;;;
;;; `exec-path-from-shell` sets your emacs accessible execution path
;;; and environment variables to match your shell on OSX.
;; Use `use-package` to configure the `exec-path-from-shell` package.
(use-package exec-path-from-shell
  :straight t  ;; Ensure that `exec-path-from-shell` is installed using `straight.el`.
  :ensure t  ;; Ensure that `exec-path-from-shell` is installed if not already present.
  :config  ;; Code to run after the package is loaded.
  )

;; Ensure the `exec-path-from-shell` package is loaded.
(require 'exec-path-from-shell)
(dolist (var '("JAVA_HOME" "PATH" "COURSIER_REPOSITORIES" "WRITER_JFROG_USER" "WRITER_JFROG_PASSWORD" "JAVA_TOOL_OPTIONS"))
  ;; For each environment variable in the list, add it to
  ;; `exec-path-from-shell-variables`. YOU WILL WANT TO CHANGE THIS
  ;; TO MATCH YOUR OWN SHELL ENVIRONMENT VARIABLES AXEL
  (add-to-list 'exec-path-from-shell-variables var))
;; Initialize the environment variables from the shell.
(exec-path-from-shell-initialize)
;;; end exec-path-from-shell

;;; helm and projectile
;;; Docs:
;;;    * Helm (https://github.com/emacs-helm/helm)
;;;    * Projectile (https://github.com/bbatsov/projectile)
;;;    * helm-projectile (https://github.com/bbatsov/helm-projectile)
;;;
;;; helm is a fuzzy completions engine. We can make emacs extremely
;;; user-friendly by using it. `M-x` is configured to run `helm-M-x`,
;;; which will allow you to fuzzy search your most recently run
;;; commands and all available commands in emacs, and display their
;;; keyboard shortcuts.
;;; Projectile scopes shell/compile commands to the local project
;;; within which you are currently browsing. Typically, it will find
;;; the project root by looking for your version control checkout or a
;;; main build file. It is very handy, as it will allow you to find
;;; non ignored files in your project in helm with `M-x
;;; helm-projectile-find-file`:`C-c h p f`, which will let you fuzzy
;;; search for files and open them. You can run your build
;;; files/compile with `M-x projectile-compile-project`:`C-c p
;;; c`. This makes working with code projects very user-friendly
;;; OOTB. There are many more projectile and helm commands, I suggest
;;; you explore them: `M-x helm-` and `M-x projectile-`.
;; Use `use-package` to install and configure the `helm-projectile` package.
(use-package helm-projectile
  :straight t  ;; Ensure that `helm-projectile` is installed using `straight.el`.
  :ensure t
  :config  ;; Code to run after the package is loaded.
  (projectile-mode +1)  ;; Enable `projectile-mode` globally.
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)  ;; Bind "C-c p" to `projectile-command-map` in `projectile-mode`.
  :bind  ;; Bind keys to specific commands.
  ("M-x" . helm-M-x)  ;; Bind "M-x" to `helm-M-x`, replacing the default `execute-extended-command`.
  ("C-c h p" . helm-projectile))  ;; Bind "C-c h p" to `helm-projectile`.
;;; end helm and projectile

;;; doom-modeline
;;; Docs: https://github.com/seagle0128/doom-modeline
;;;
;;; doom-modeline makes the status bar (that grey bar above the menu buffer) much more user-friendly, by displaying information in icons and making it easier to read.
;; Use `use-package` to install and configure the `doom-modeline` package.
(use-package doom-modeline
  :ensure t
  :straight t)
(require 'doom-modeline)
(doom-modeline-mode 1)  ;; Enable `doom-modeline-mode` with an argument of 1, which activates it.
  
;;; end doom-modeline

;;; flycheck
;;; Docs: https://www.flycheck.org/en/latest/
;;;
;;; Flycheck is an advanced syntax/linter/error checking minor mode
;;; that is used in many programming modes. It allows you to view
;;; errors both inline and in a buffer. You can use it with `M-x
;;; flycheck-` and picking a command from the list.
;; Use `use-package` to install and configure the `flycheck` package.
(use-package flycheck
  :init  ;; Code to run before the package is loaded.
  (global-flycheck-mode))  ;; Enable `global-flycheck-mode`, which activates Flycheck in all buffers where it is applicable.
;;; end flycheck

;;; npm-mode
;;; Docs: https://github.com/mojochao/npm-mode
;;;
;;; `npm-mode` allows you to work with npm from within emacs. It is
;;; the situation today, that quite often we have to work with
;;; javascript or typescript or tools that use them internally. This
;;; comes in handy.
;;;
;;; You can launch it with `M-x npm-mode` when you need to use it.
;; Use `use-package` to install and configure the `npm-mode` package.
(use-package npm-mode
  :ensure t
  :straight t)
;;; end npm-mode


;;; themes
;;; Docs:
;;;    * almost-mono-themes (https://github.com/cryon/almost-mono-themes)
;;;    * tao-theme (https://github.com/11111000000/tao-theme-emacs)
;;;    * doom-themes (https://github.com/doomemacs/themes)
;;;
;;; Color themes for syntax highlighting, selection, etc. You can
;;; select and browse themes with `M-x customize-themes`. Some require
;;; additional :config entries in their use-package statemens if you
;;; select them to be user-friendly. Please consult their
;;; documentation when you enable a theme.
;; Use `use-package` to install and configure the `almost-mono-themes` package.
(use-package almost-mono-themes
  :ensure t
  :straight t)
;; Use `use-package` to install and configure the `tao-theme` package.
(use-package tao-theme
  :ensure t
  :straight t)
;; Use `use-package` to install and configure the `doom-themes` package.
(use-package doom-themes
  :ensure t  ;; Ensure that `doom-themes` is installed if it isn't already.
  :straight t
  :config  ;; Code to run after the package is loaded.
  (setq doom-themes-enable-bold t    ;; Enable bold text in Doom themes (set to nil to disable).
        doom-themes-enable-italic t) ;; Enable italic text in Doom themes (set to nil to disable).
  )
;;; end themes

;;; expand-region
;;; Docs: https://github.com/magnars/expand-region.el
;;;
;;; expand region allows for expanding and contracting the selected
;;; region. It's useful for selecting part of an expression, then
;;; expanding it gradually (expression to wider control expression,
;;; widen to function body, widen to function, widen to class body,
;;; widen to file, etc.). It makes selecting things extremely quick
;;; without requiring exact keyboard navigation.
;; Use `use-package` to install and configure the `expand-region` package.
(use-package expand-region
  :bind ("C-=" . er/expand-region))  ;; Bind the "C-=" key to the `er/expand-region` command.
;;; end expand-region

;;; smartparens
;;; Docs: https://github.com/Fuco1/smartparens
;;;
;;; smartparens identifies matching parenthesis/brackets/quotations
;;; and will insert matching ones for you automatically when you open
;;; one. It saves a lot of typing, and hunting for matching opening or
;;; closing characters.
;; Use `use-package` to install and configure the `smartparens` package.
(use-package smartparens
  :config  ;; Code to run after the package is loaded.
  (require 'smartparens-config))  ;; Load the default configuration for `smartparens`.
;;; end smartparens

;;; ace-jump-mode
;;; Docs: https://github.com/winterTTr/ace-jump-mode
;;;
;;; ace-jump-mode allows you to quickly jump to any character on the
;;; screen, which makes navigation very quick and easy. The following
;;; keys are bound for you:
;;;    * `M-x ace-jump-mode`: `C-c SPC <character>` --
;;;        will display keys to type to jump to the matching
;;;        <character> at the start of words on the screen
;;;    * `C-u C-c SPC <character>` --
;;;        will display keys to type to jump to the matching
;;;        <character> in any place in words on the screen
;;;    * `M-x ace-jump-mode-pop-mark`: `C-c ,` --
;;;        returns to the previous position after jumping
;;;    * `M-x ace-swap-window`: `C-c w` --
;;;        When multiple windows are available, swaps the
;;;        unselected buffer with the one currently under the cursor.
;; Use `use-package` to install and configure the `ace-jump-mode` package.
(use-package ace-jump-mode
  :ensure t
  :straight t
  :config  ;; Code to run after the package is loaded.
  (autoload  ;; Automatically load `ace-jump-mode-pop-mark` when it is first used.
    'ace-jump-mode-pop-mark  ;; The function to autoload.
    "ace-jump-mode"  ;; The file where the function is defined.
    "Ace jump back:-)"  ;; A short documentation string for the function.
    t)  ;; Make the command available globally.
  (eval-after-load "ace-jump-mode"  ;; Evaluate the following forms after `ace-jump-mode` is loaded.
    '(ace-jump-mode-enable-mark-sync))  ;; Enable synchronization of the mark in `ace-jump-mode`.
  :bind (("C-c SPC" . ace-jump-mode)  ;; Bind "C-c SPC" to start `ace-jump-mode`.
         ("C-c ," . ace-jump-mode-pop-mark)  ;; Bind "C-c ," to jump back to the previous location.
         ("C-c w" . ace-swap-window)))  ;; Bind "C-c w" to swap windows using `ace-swap-window`.
;;; end ace-jump-mode

;;; duplicate-thing
;;; Docs: https://github.com/ongaeshi/duplicate-thing
;;;
;;; Does what it says on the tin. Will copy the current line or
;;; selection. Bound to `C-c d`.
;; Use `use-package` to install and configure the `duplicate-thing` package.
(use-package duplicate-thing
  :ensure t
  :straight t
  :bind ("C-c d" . duplicate-thing))  ;; Bind "C-c d" to the `duplicate-thing` command.
;;; end duplicate-thing

;;; god-mode
;;; Docs: https://github.com/emacsorphanage/god-mode
;;;
;;; Modal Editing in emacs. Bound to `C-c .` Allows you to avoid using
;;; the Ctrl and Meta keys when enabled, by capturing keystrokes and
;;; spaces and prefix keys. Any key without a space or `g` typed
;;; before it is interpreted as `C-<key>`, spaces are interpeted as
;;; <key>, and any key prefixed by `g` is interpreted as
;;; `M-<key>`. This greatly reduces the amount of key chords you have
;;; to write, and makes navigating and editing extremely efficient
;;; without having to rewrite all the keyboard shortcuts to accomodate
;;; modal editing, like in evil/doom/spacemacs. It just changes the
;;; chords to sequences instead.
;; Use `use-package` to install and configure the `god-mode` package.
(use-package god-mode
  :ensure t
  :straight t
  :bind ("C-c ." . god-local-mode))  ;; Bind "C-c ." to the `god-local-mode` command.
;;; end god-mode


;;; switch-window
;;; Docs: https://github.com/dimitri/switch-window
;;;
;;; Emacs displays multiple buffers using a tiled layout. Each buffer
;;; is stored in a window. Switch-window makes jumping to any window
;;; or removing the window from the tiled layout a matter of hitting
;;; the correct key binding and the number of the window. Please
;;; explore it with `M-x switch-window`).
;; Use `use-package` to install and configure the `switch-window` package.
(use-package switch-window
  :ensure t
  :straight t
  :bind
  ;; Bind keys to various commands provided by `switch-window`.
  ("C-x o" . switch-window)  ;; Replace default `other-window` to use `switch-window`.
  ("C-x 1" . switch-window-then-maximize)  ;; Maximize the current window after switching.
  ("C-x 2" . switch-window-then-split-below)  ;; Split the window below after switching.
  ("C-x 3" . switch-window-then-split-right)  ;; Split the window to the right after switching.
  ("C-x 0" . switch-window-then-delete)  ;; Delete the current window after switching.
  ("C-x 4 d" . switch-window-then-dired)  ;; Open `dired` in another window after switching.
  ("C-x 4 f" . switch-window-then-find-file)  ;; Open a file in another window after switching.
  ("C-x 4 r" . switch-window-then-find-file-read-only)  ;; Open a file read-only in another window after switching.
  ("C-x 4 C-f" . switch-window-then-find-file)  ;; Another binding to open a file after switching.
  ("C-x 4 C-o" . switch-window-then-display-buffer)  ;; Display buffer in another window after switching.
  ("C-x 4 0" . switch-window-then-kill-buffer))  ;; Kill a buffer and then switch window.
;;; end switch-window

;;; frog-jump-buffer
;;; Docs: https://github.com/waymondo/frog-jump-buffer
;;;
;;; Keeping with the theme of making navigation easy in emacs,
;;; frog-jump-buffer displays a shortened list of your most-recently
;;; visited buffers in a popup with a hydra (a set of keys to type to
;;; perform an action in a textual ui menu). Makes switching between
;;; buffers that you use frequently a breeze. Bound to `C-c b`.
;; Use `use-package` to install and configure the `frog-jump-buffer` package.
(use-package frog-jump-buffer
  :ensure t
  :straight t
  :bind ("C-c b" . frog-jump-buffer))  ;; Bind "C-c b" to the `frog-jump-buffer` command.
;;; end frog-jump-buffer

;;; which-key
;;; Docs: https://github.com/justbur/emacs-which-key
;;;
;;; When typing a keyboard shortcut, displays a menu of the next keys
;;; to press and what they will call when pressed. Makes learning and
;;; using keyboard shortcuts extremely easy.
;; Use `use-package` to install and configure the `which-key` package.
(use-package which-key
  :ensure t  ;; Ensure that `which-key` is installed if it isn't already.
  :config  ;; Code to run after the package is loaded.
  (which-key-mode t))  ;; Enable `which-key` mode globally.
(require 'which-key)
(which-key-mode t)
;;; end which-key

;;; goto-chg
;;; Docs: https://github.com/emacs-evil/goto-chg
;;;
;;; Allows you to jump in the buffer to the last edit, and to jump
;;; back to where you were before jumping. Cycles through changes as
;;; far is it can. `M-x goto-last-change`: `C-x C-\` -- goes to last
;;; change, cyclically. `M-x goto-last-change-reverse`: `C-x C-/`,
;;; jumps back through the list of edits.
;; Use `use-package` to install and configure the `goto-chg` package.
(use-package goto-chg
  :bind  ;; Bind keys to commands provided by `goto-chg`.
  (("C-x C-\\" . goto-last-change)  ;; Bind "C-x C-\\" to `goto-last-change`.
   ("C-x C-/" . goto-last-change-reverse)))  ;; Bind "C-x C-/" to `goto-last-change-reverse`.
;;; end goto-chg

;;; hl-column
;;; Docs: https://codeberg.org/akib/emacs-hl-column
;;;
;;; Highlights the current column. Useful for whitespace-significant
;;; things, yaml, python, etc.
;; Use `use-package` to install and configure the `hl-column` package.
(use-package hl-column
  :config  ;; Code to run after the package is loaded.
  (global-hl-column-mode t))  ;; Enable `global-hl-column-mode` globally.
;;; end hl-column

;;; magit
;;; Docs: https://magit.vc/
;;;
;;; Git for emacs with hydras (textual uis where you press the keys
;;; displayed to run your desired command). READ THE DOCS, it is
;;; extremely powerful and quick to use once you learn it. This is one
;;; of THE killer apps in emacs. It's a heck of a drug.
;; Use `use-package` to install and configure the `magit` package.
(use-package magit
  :config  ;; Code to run after the package is loaded.
  (setq-default transient-default-level 7)  ;; Set the default transient level to 7.
  :bind ("C-x g" . magit-status))  ;; Bind "C-x g" to the `magit-status` command.
;;; end magit

;;; forge
;;; Docs: https://github.com/magit/forge
;;;
;;; Adds git forge (github/gitlab/bitbucket/etc.) capabilities to
;;; magit in emacs.
;; Use `use-package` to install and configure the `forge` package.
(use-package forge
  :ensure t
  :straight t
  :after magit)  ;; Load `forge` after the `magit` package has been loaded.
;;; end forge

;;; seethru
;;; Docs: https://github.com/Benaiah/seethru
;;;
;;; Allows you to change the transparency of the emacs
;;; application. This can be handy when you need to read some
;;; documentation or watch a video while you are working. Use it with
;;; `M-x seethru`.
;; Use `use-package` to install and configure the `seethru` package.
(use-package seethru
  :ensure t
  :straight t)
;;; end seethru

;;; kubernetes
;;; Docs: https://github.com/kubernetes-el/kubernetes-el
;;;
;;; Allows you to manage, inspect, follow logs, etc. in kubernetes
;;; directly within emacs. No cli necessary. Again, uses a hydra
;;; (textual ui). You will need to be logged into writer,and have
;;; initialized your kubernetes global configuration, but then you can
;;; enter the overview with `M-x kubernetes-overview`, and change
;;; contexts with `M-x kubernetes-use-context <name>`. Hit `?` to see
;;; what you can do once there.
(use-package kubernetes
  :ensure t
  :straight t)
;;; end kubernetes

;;; string-inflection
;;; Docs: https://github.com/akicho8/string-inflection
;;;
;;; Change the casing of words. See the bindings below, but you can
;;; swap between camelCase, PascalCase, lisp-case, snake_case, etc.
(use-package string-inflection
  :ensure t
  :straight t
	:bind(
				("C-c i a" . string-inflection-all-cycle)
				("C-c i c" . string-inflection-cycle)
				("C-c i l" . string-inflection-lisp)
				("C-c i C" . string-inflection-lower-camelcase)
				)
	)
;;; end string-inflection

;;; terminal color settings
;;;
;;; Makes it so that escape sequences from shell commands show correctly in compilation buffers:
;; Require the `ansi-color` package, which provides support for handling ANSI color sequences.
(require 'ansi-color)

;; Define a new function to colorize compilation buffers.
(defun colorize-compilation-buffer ()
  ;; Apply ANSI color codes starting from `compilation-filter-start` to the current point.
  (ansi-color-apply-on-region compilation-filter-start (point)))

;; Add the newly defined function to the `compilation-filter-hook`.
;; This hook runs during compilation processes, specifically when output is inserted into the buffer.
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
;;; end terminal color settings

;;; rest client
;;; Docs: https://github.com/pashky/restclient.el
;;;
;;; Allows you to create files and interact with http requests you
;;; store in them and receive the responses in emacs. Also you can
;;; store state in elisp expressions and use the expressions in the
;;; requests.
;; Use `use-package` to install and configure the `restclient` package.
(use-package restclient
  :ensure t  ;; Ensure that `restclient` is installed if it isn't already.
  :straight t
  :mode (("\\.http\\'" . restclient-mode)))  ;; Associate `restclient-mode` with files ending in `.http`.
;;; end rest client

;;; docker
;;; Docs: https://github.com/Silex/docker.el
;;;
;;; Allows you to run docker containers within emacs. `M-x docker`.
;; Use `use-package` to install and configure the `docker` package.
(use-package docker
  :ensure t
  :straight t
  )
;;; end docker
;;;    --- End Package Selection and Configuration ---

;;;    --- IDE ---

;;; yasnippet
;;; Docs: https://github.com/joaotavora/yasnippet
;;;
;;; Templating system for emacs. Lets you create and load templates
;;; for use, and bind them to completions and keyboard shortcuts,
;;; which makes editing quicker.
;; Use `use-package` to install and configure the `yasnippet` package.
(use-package yasnippet)
;;; end yasnippet

;;; scala-mode
;;; Docs: https://github.com/hvesalai/emacs-scala-mode
;;;
;;; Syntax highlighting and editing mode for scala 2 and scala 3.
;; Define a new function `prettify-scala` to configure prettify symbols specific to Scala.
(defun prettify-scala ()
  "Set scala prettify symbols for scala mode."
  (setq prettify-symbols-alist scala-prettify-symbols-alist)  ;; Set the `prettify-symbols-alist` to the predefined `scala-prettify-symbols-alist`.
  (prettify-symbols-mode 1))  ;; Enable `prettify-symbols-mode`.

;; Use `use-package` to install and configure the `scala-mode` package.
(use-package scala-mode
  :mode ("\\.\\(scala\\|sbt\\|sc\\)\\'" . scala-mode)  ;; Associate Scala-related file extensions with `scala-mode`.
  :interpreter ("scala" . scala-mode)  ;; Use `scala-mode` for Scala scripts that are executable.
  :hook ((scala-mode . lsp)  ;; Enable Language Server Protocol (LSP) support when entering `scala-mode`.
         (scala-mode . prettify-scala)))  ;; Call `prettify-scala` when entering `scala-mode`.
;;; end scala

;;; lsp-mode
;;; Docs: https://emacs-lsp.github.io/lsp-mode/
;;;
;;; lsp-mode allows you to use language servers to turn emacs into an
;;; ide for pretty much every major language that you are likely to
;;; use. Emacs 29 comes with a different lsp server, but it is much
;;; more difficult to configure and use. lsp-mode is well-documented
;;; and detects languages well, and will mostly automatically install
;;; them as long as the system requirements for a language server can
;;; be met. `M-x lsp-mode` will start it and ask to import the local
;;; project into your workspace, which is stored in your `emacs.d`
;;; directory. You can also install or update your local copies of
;;; language servers. I reccomend exploring it with `M-x lsp-`.
;;;
;;; Many languages (such as python) may require additional
;;; configuration. Here I've configured pyright for you as I've had
;;; really good luck with it, but you can find the manual
;;; configurations for each supported language here:
;;; https://emacs-lsp.github.io/lsp-mode/page/languages/.
;;;
;;; I've also included a scala lsp and yaml lsp, which require some
;;; special considerations. Most other languages will
;;; auto-install. You should update the :hook section of individual
;;; languages within which you want to use lsp to automatically start
;;; lsp-mode.
;;;
;;; You will notice that I've separated this as a special section away
;;; from the other packages and configuration. This is to make it
;;; clear that something is part of the IDE capabilities of the
;;; config.
;; Use `use-package` to install and configure the `lsp-mode` package for Language Server Protocol support in Emacs.
(use-package lsp-mode
  :ensure t
  :straight t
  :hook  
  ;; Attach `lsp-lens-mode` and `yas-minor-mode` to `lsp-mode` for enhanced functionality.
  (lsp-mode . lsp-lens-mode)  ;; Enable `lsp-lens-mode` when `lsp-mode` is active.
  (lsp-mode . yas-minor-mode)  ;; Enable `yas-minor-mode` for snippet support in `lsp-mode`.
  :config
  ;; Optional performance tuning settings for `lsp-mode`. These are commented out by default but can be uncommented to improve performance.
  ;; (setq gc-cons-threshold 100000000) ;; Increase garbage collection threshold to 100mb to reduce pauses.
  ;; (setq read-process-output-max (* 1024 1024)) ;; Increase the process output read limit to 1mb for better performance.
  ;; (setq lsp-idle-delay 0.500)  ;; Increase delay before LSP is idle.
  ;; (setq lsp-log-io nil)  ;; Disable logging of LSP IO to improve performance.
  ;; (setq lsp-completion-provider :capf)  ;; Use the `capf` completion framework.
  (setq lsp-prefer-flymake nil)  ;; Prefer `lsp-ui` (or others) over `flymake` for showing diagnostics.
  )
;;; lsp-ui
;;; Docs: https://github.com/emacs-lsp/lsp-ui
;;;
;;; Adds inline lsp action commands, docs on hover, etc.
(use-package lsp-ui
  :ensure t
  :straight t)
;;; end lsp-ui

;;; posframe
;;; Docs: https://github.com/tumashu/posframe
;;;
;;; Necessary for showing debugging popups with dap mode
(use-package posframe)
;;; end posframe

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package dap-mode
  :ensure t
  :straight t
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
	)
;;; end lsp-mode

;;; metals
;;; Docs: https://scalameta.org/metals/
;;;
;;; Metals is the scala language server.
(use-package lsp-metals
  :ensure t
  :straight t
  )
;;; end metals

;;; lsp-java
(use-package lsp-java
  :ensure t
  :straight t
  :config (add-hook 'java-mode-hook 'lsp))
;;; end lsp-java

;;; pyright (lsp python server)
;;; Docs: https://emacs-lsp.github.io/lsp-pyright/
;;; Configuration Docs: https://github.com/microsoft/pyright/blob/main/docs/configuration.md
;;;
;;; Pyright is a lightweight python language server that tends to work
;;; really well.
(use-package lsp-pyright
  :ensure t
  :straight t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred
;;; end pyright
;;; end lsp

;;; company
;;; Docs:
;;;
;;; company is another completions framework for emacs, used by most
;;; lsp modes to provide inline-completions. You enable it with `M-x
;;; company-mode`. Add you language mode hooks to the :hook section
;;; here like I did for scala.
(use-package company
  :hook (scala-mode . company-mode) (scala-mode . hs-minor-mode) (scala-mode . smartparens-mode)
  :config
  (setq lsp-completion-provider :capf))
;;; end company


;;; copilot
;;; Docs: https://github.com/copilot-emacs/copilot.el
;;;
;;; copilot is a copilot ai generated completion framework. You need a
;;; license to run it. Optionally uncomment this and follow the
;;; instructions in the docs link to use it, and add it to the language
;;; modes you want by adding another entry in the associative list
;;; under :config.
;; (use-package copilot
;;   :straight t
;;   :hook (prog-mode . copilot-mode)
;;   :config
;;   (add-to-list 'copilot-major-mode-alist '("scala-mode" . "scala"))
;;   :bind
;;   (
;; 				("C-c C-x a" . copilot-accept-completion)
;; 				("C-c C-x n" . copilot-next-completion)
;; 				("C-c C-x p" . copilot-previous-completion)
;; 				)
;;   )
;;; end copilot

;;;     --- End IDE ---

;;; REMEMBER TO `M-x customize-face default` to set your default font,
;;; and `M-x customize-group <package> <tab> to set settings for the
;;; various packages here.


;;; REMEMBER to select a good theme with `M-x customize-themes`.

;;; REMEMBER to turn off the init screen with `M-x customize-group
;;; initialize`. I usually inhibit startup buffers.

;;; REMEMBER to turn off any parts of the UI you don't need:
;;; scrollbars, menubars, tabbars, etc. You can do this by searching
;;; within `M-x customize <ENTER>`.

;;; There you go Axel -- a working, vanilla emacs config as an ide in
;;; under 500 lines of code (minus comments), that will literally
;;; allow you to `M-x` and fuzzy search for anything you want to do,
;;; show you the keyboard shortcuts, and get completions, with plenty
;;; of examples for stuff you want to expand.










(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-one))
 '(custom-safe-themes
   '("88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "38c0c668d8ac3841cb9608522ca116067177c92feeabc6f002a27249976d7434" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" default))
 '(lsp-metals-mill-script "./mill"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
