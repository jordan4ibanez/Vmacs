# Vmacs
 My attempt to turn Emacs into VSCode
```
 __     __                                
 \ \   / / _ __ ___     __ _    ___   ___ 
  \ \ / / | '_ ` _ \   / _` |  / __| / __|
   \ V /  | | | | | | | (_| | | (__  \__ \
    \_/   |_| |_| |_|  \__,_|  \___| |___/
```

This was bootstrapped in vscode. (It was a nightmare)

This was used as a guide: https://github.com/MAlba124/memacs

This is built off, translated from: https://github.com/MAlba124/luamacs

Then I followed this tutorial and translated even more: https://github.com/DevelopmentCool2449/visual-emacs

This was used to build the use-package api: https://github.com/jwiegley/use-package

For Ubuntu distros:

```
sudo apt install liblua5.2-dev
```

If running vim mode in emacs is considered evil, this is downright apocalyptic.

Install a D compiler. I recommend LDC2.

//! note: if you functioncall into your own function it's gonna blow up.
// functioncall(emacs_environment, "testing", 1, {"hi"})

I can't find a list of elisp functions so I have to read RTFM:
https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html

This is true horror.