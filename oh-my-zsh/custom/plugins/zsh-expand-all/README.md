zsh-expand-all
========
This plugin let your zsh automatically expands all glob expressions,
subcommands, normal aliases, and [global aliases].

Try it with [zinit], or your favorite plugin manager.

```zsh
zinit light simnalamburt/zsh-expand-all
```

Then just use your zsh as usual. Your aliases will be automatically expanded.
If you only want to insert a space without expanding the command line, press
<kbd>ctrl</kbd> + <kbd>space</kbd>.

<br>

Examples
--------

#### Glob expressions

```console
$ touch {1..10}<space>
# expands to
$ touch 1 2 3 4 5 6 7 8 9 10

$ ls **/*.json<space>
# expands to
$ ls folder/file.json anotherfolder/another.json
```

#### Subcommands

```console
$ mkdir "`date -R`"
# expands to
$ mkdir Tue,\ 04\ Oct\ 2016\ 13:54:03\ +0300

```

#### Aliases

```console
# .zshrc:
alias -g G="| grep --color=auto -P"
alias l='ls --color=auto -lah'

$ l<space>G<space>
# expands to
$ ls --color=auto -lah | grep --color=auto -P
```

```console
# .zsrc:
alias S="sudo systemctl"

$ S<space>
# expands to:
$ sudo systemctl
```

<br>

Disabling certain features with `$ZSH_EXPAND_ALL_DISABLE`
--------
You can disable certain features with `$ZSH_EXPAND_ALL_DISABLE` environment
variable.

```zsh
ZSH_EXPAND_ALL_DISABLE=             # All features are enabled
ZSH_EXPAND_ALL_DISABLE=alias        # Disable alias expanding
ZSH_EXPAND_ALL_DISABLE=word         # Disable word expanding
ZSH_EXPAND_ALL_DISABLE=alias,word   # Disable alias and word expanding
```

<br>

References
--------
This project was forked from [globalias] of Oh My Zsh.

- [zshmisc](http://strcat.de/dotfiles/dot.zshmisc),
  Christian 'strcat' Schneider
- [ZSH Abbreviations](https://hackerific.net/2009/01/23/zsh-abbreviations/),
  Matt Foster, 2009-01-23
- [Cloning vim's abbreviation feature](http://zshwiki.org/home/examples/zleiab),
  Mikachu, 2011-04-22
- [Automatically Expanding zsh Global Aliases As You Type](https://blog.patshead.com/2011/07/automatically-expanding-zsh-global-aliases-as-you-type.html),
  Pat Regan, 2011-07-08
- [Automatically Expanding zsh Global Aliases - Simplified](https://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html),
  Pat Regan, 2012-11-04

<br>

--------
*zsh-expand-all* is primarily distributed under the terms of both the [MIT
license] and the [Apache License (Version 2.0)]. See [COPYRIGHT] for details.

[global aliases]: http://www.zshwiki.org/home/examples/aliasglobal
[zinit]: https://github.com/zdharma/zinit
[globalias]: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/globalias
[MIT license]: LICENSE-MIT
[Apache License (Version 2.0)]: LICENSE-APACHE
[COPYRIGHT]: COPYRIGHT
