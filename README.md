*node-pinboard-cli*
**Use [pinboard.in](https://pinboard.in) from the command line.**
***Almost feature complete!***

Uses [node-pinboard](https://npmjs.org/package/node-pinboard) and [commanderjs](http://tj.github.io/commander.js/).

```
$> pinboard help

  Usage: pinboard [action]


  Commands:

    add <url> <desc>  add a bookmark
    all               all the bookmarks in your account
    dates             bookmarks separated by date
    delete <url>      delete a bookmark
    get               get bookmark(s)
    recent            most recent bookmarks (default action)
    secret            your secret feed's RSS key
    suggest <url>     suggest tags
    update            datetime of most recent action
    help [cmd]        display help for [cmd]

  Use pinboard.in from the command line.

  Options:

    -h, --help     output usage information
    -V, --version  output the version number
```
