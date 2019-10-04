'use strict'

argv = (options) ->
  { indexOf, intersection, last } = require('lodash')
  args = process.argv.concat()
  list = [ '--help', '' ]
  req = []

  req.push(o.long, o.short) for o in options when (o.required < 0)
  args.push('') if indexOf(req, last(args)) is -1 and intersection(list, args).length < 1
  return args

define = (description) ->
  require('commander')
    .version require('../package').version
    .description description

  return

one = (pri, sec) ->
  return if (pri? and sec?) then (pri or sec) else sec

pinboard: ->
  require('node-env-file')("#{ __dirname }/.env")
  { PINBOARD_TOKEN } = process.env
  { notEqual } = require('assert')

  try
    notEqual PINBOARD_TOKEN, 'user:XXXXXXXXXXXXXXXXXXXX'
    new (require './pinboard')(PINBOARD_TOKEN)

  catch
    console.error 'PINBOARD_TOKEN environment variable not found.'
    process.exit yes

  return

yesno = (what) ->
  return undefined unless what?
  return if (what is yes) then 'yes' else 'no'

module.exports = { argv, define, one, pinboard, yesno }
