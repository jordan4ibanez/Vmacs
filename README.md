# Vmacs
 My attempt to turn Emacs into VSCode
```
 __     __                                
 \ \   / / _ __ ___     __ _    ___   ___ 
  \ \ / / | '_ ` _ \   / _` |  / __| / __|
   \ V /  | | | | | | | (_| | | (__  \__ \
    \_/   |_| |_| |_|  \__,_|  \___| |___/
```

Fun fact: This was bootstrapped with VSCode. :D

### How to install:
Git clone this into a folder called ``.emacs.d`` in your home directory.
Start Emacs, it'll automatically start to install.

TODO:

~~ctrl+/ to comment out region with ``'comment-region``~~ (WOOO)

~~reopen old tabs~~ (works :D)

~~paste with selection region overwrite~~

~~shortcuts for enabling/disabling treemacs~~ (F5)

~~fix delete key not deleting a selected region~~ (WOOOO!)

common lisp tools.

Maybe some sort of linting?

Maybe some sort of autocomplete/smart suggest?

Hook up slime.

Add DrRacket SLY commands to make this thing an absolute beast.

## Package manager:

[MELPA](https://melpa.org/)

## Bundled packages:

[Doom-themes](https://github.com/doomemacs/themes) (The theme)

[ergoemacs-mode](https://github.com/ergoemacs/ergoemacs-mode) (Gives sane key shortcuts)

[all-the-icons](https://github.com/domtronn/all-the-icons.el) (Icons)

[centaur-tabs](https://github.com/ema2159/centaur-tabs) (Workspace tabs)

[Treemacs](https://github.com/Alexander-Miller/treemacs) (Tree layout on left side)

[Dashboard](https://github.com/emacs-dashboard/emacs-dashboard) (The dashboard)

;; Lispy stuff!

[ParEdit](https://www.emacswiki.org/emacs/ParEdit) (Lisp parenthesis balancer)

[highlight-parentheses](https://sr.ht/~tsdh/highlight-parentheses.el/) (Makes it easier to understand bracket scope)

[rainbow-delimeters](https://github.com/Fanael/rainbow-delimiters) (Fancy rainbow brackets (disabled by default))

In between slime and sly, whichever is easier to install


Notes:

You can run the terminal with ``ansi-term`` perhaps this can be linked to ``ctrl-~``

Ican'tThinkOfAGoodName's ideas:

You can remove the call to package-initialize. It's not necessary since Emacs 27.

Smooth scrolling is included with Emacs as of version 29.1. You don't need sublimity - just enable pixel-scroll-precision-mode.

Rather than installing packages with package-install, you should use use-package. (use-package my-package :ensure t) is all you need. If you set use-package-always-ensure to t, the :ensure t is not needed.


define-key is a legacy function. Use keymap-set instead.


You shouldn't kill the Messages buffer. It will contain useful debugging information. Besides, whenever some code sends a message, the buffer will get created again.


That custom-set-variables is created by Emacs' Customize interface. https://www.gnu.org/software/emacs/manual/html_node/emacs/Easy-Customization.html


You can make this go in a different file by modifying the custom-file variable.