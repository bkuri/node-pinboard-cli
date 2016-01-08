*node-pinboard-cli*
**Use [pinboard.in](https://pinboard.in) from the command line.**
***Almost feature complete!***

Uses [node-pinboard](https://npmjs.org/package/node-pinboard) and [commanderjs](http://tj.github.io/commander.js/).

**Setup:**
You must specify a valid pinboard api token to use this tool. You can [find it here](https://pinboard.in/settings/password) after logging in.

Simply copy the token and paste it as an environment variable with the name `PINBOARD_TOKEN`. In Linux and OSX it looks like this:
```
export PINBOARD_TOKEN=user:XXXXXXXXXXXXXXXXXXXX
```

You can optionally set environment variables to set the default output format and verbosity like so:
```
export PINBOARD_FORMAT=json
export PINBOARD_VERBOSE=true
```

After that you're ready to start using.

**Usage:**
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
