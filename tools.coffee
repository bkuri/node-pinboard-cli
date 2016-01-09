'use strict'


{intersection} = require('lodash')

module.exports =
  argv: ->
    argv = process.argv.concat()
    list = ['--help', '']

    argv.push('') unless intersection(list, argv).length > 0
    return argv


  define: (description) ->
    (require 'commander')
      .version (require './package').version
      .description description


  format: (which) ->
    return (data, type='result') ->
      out = switch which
        when 'color'
          chalk = (require 'chalk')
          data = data.posts if data.posts?
          text = '\n\n'

          render = (key, value) ->
            switch type
              when 'bookmark'
                """
                #{chalk.bold.white key.description}
                #{chalk.yellow key.tags or '--'}
                #{chalk.dim.gray key.href}\n\n
                """

              when 'date', 'tags' then "#{chalk.bold.white key}: #{value}\n"
              when 'error' then chalk.bold.red(key)
              else chalk.bold.green(key[type])

          if Array.isArray(data)
            switch type
              when 'tags' then text += render(b, data[i][b].join ', ') for b, i in ['popular', 'recommended']
              else text += render(item) for item in data

          else if data.dates?
            text += render(k, data.dates[k]) for k in Object.keys(data.dates)

          else text = render(data)

          if chalk.supportsColor then text else chalk.stripColor(text)

        when 'json' then JSON.stringify(data)


      isError = (type is 'error')

      if isError then console.error(out) else console.log(out)
      process.exit isError


  one: (pri, sec) ->
    if (pri? and sec?) then (pri or sec) else sec


  pinboard: ->
    {notEqual} = (require 'assert')
    (require 'node-env-file')("#{__dirname}/.env")

    try
      notEqual process.env.PINBOARD_TOKEN, 'user:XXXXXXXXXXXXXXXXXXXX'
      new (require './Pinboard')(process.env.PINBOARD_TOKEN)

    catch
      console.error 'PINBOARD_TOKEN env variable not found.'
      process.exit yes


  yesno: (what) ->
    return undefined unless what?
    if (what is yes) then 'yes' else 'no'
