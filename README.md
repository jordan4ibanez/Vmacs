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

ctrl+/ to comment out region with ``'comment-region``

reopen old tabs

paste with selection region overwrite

common lisp tools

~~shortcuts for enabling/disabling treemacs~~ (F5)

Hook up SLY.
OR use slime?

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