'use strict'


module.exports =
  argv: (options) ->
    {indexOf, intersection, last} = require('lodash')
    argv = process.argv.concat()
    list = ['--help', '']
    req = []

    req.push(o.long, o.short) for o in options when (o.required < 0)
    argv.push('') if indexOf(req, last(argv)) < 0 or intersection(list, argv).length
    return argv


  define: (description) ->
    require('commander')
      .version (require '../package').version
      .description description


  one: (pri, sec) ->
    if (pri? and sec?) then (pri or sec) else sec


  pinboard: ->
    require('node-env-file')("#{__dirname}/.env")
    {PINBOARD_TOKEN} = process.env
    {notEqual} = (require 'assert')

    try
      notEqual PINBOARD_TOKEN, 'user:XXXXXXXXXXXXXXXXXXXX'
      new (require './pinboard')(PINBOARD_TOKEN)

    catch
      console.error 'PINBOARD_TOKEN environment variable not found.'
      process.exit yes


  yesno: (what) ->
    return undefined unless what?
    if (what is yes) then 'yes' else 'no'
