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

First there was emacs, then there was evil mode, crazy mode after that.

I present to you: Lazy mode.

### How to install:
It is expected that you have SBCL installed and in your system path.

If you're unsure of this, try running ``sbcl`` in your terminal/command prompt.

Git clone this into a folder called ``.emacs.d`` in your home directory.
Start Emacs, it'll automatically start to install.

A small note: The first time you start it up it's going to take a minute to install all the packages.

Once it gets to the dashboard, let all the warnings with SLIME finish (wrongly documented functions etc) and then close and open back up emacs.

If you don't want to ever check for updates, or maybe only once in a while, I have ``turn-on-automatic-package-updates``. I recommend once in a while because it slows down startup a lot. 

Should be good from there on out.

### TODO:

CTRL+BACKSPACE deletes the indentation OR word

Autosave

See if there is a way to remember where the buffer was scrolled when reopening files



common lisp tools.

Maybe some sort of linting?


## Package manager:

[MELPA](https://melpa.org/)

## Bundled packages:

[Doom-themes](https://github.com/doomemacs/themes) (The theme)

[ergoemacs-mode](https://github.com/ergoemacs/ergoemacs-mode) (Gives sane key shortcuts)

[all-the-icons](https://github.com/domtronn/all-the-icons.el) (Icons)

[centaur-tabs](https://github.com/ema2159/centaur-tabs) (Workspace tabs)

[Treemacs](https://github.com/Alexander-Miller/treemacs) (Tree layout on left side)

[Dashboard](https://github.com/emacs-dashboard/emacs-dashboard) (The dashboard)

[CTRLF](https://github.com/radian-software/ctrlf) (The <u>**BEST**</u> search utility I could find!)

[corfu.el](https://github.com/minad/corfu) (Autocomplete - Set to INSTANT by default.)

[diff-hl](https://github.com/dgutov/diff-hl) (Shows uncommitted lines in the gutter)

;; Lispy stuff!

[ParEdit](https://www.emacswiki.org/emacs/ParEdit) (Lisp parenthesis balancer)

[highlight-parentheses](https://sr.ht/~tsdh/highlight-parentheses.el/) (Makes it easier to understand bracket scope)

[rainbow-delimeters](https://github.com/Fanael/rainbow-delimiters) (Fancy rainbow brackets (disabled by default))


### Notes:

- You can run the terminal with ``ansi-term`` perhaps this can be linked to ``ctrl-~``

- Document the key bindings. They're in the code, put them somewhere legible.

### Ican'tThinkOfAGoodName's ideas:

- You shouldn't kill the *Messages* buffer. It will contain useful debugging information. Besides, whenever some code sends a message, the buffer will get created again.
>^ Going to test this.

- You can make this go in a different file by modifying the custom-file variable.
>^ Going to look into this