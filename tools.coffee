'use strict'


module.exports =
  argv: ->
    argv = process.argv.concat()

    argv.push ''
    return argv


  define: (description) ->
    (require 'commander')
      .version (require './package').version
      .description description


  one: (pri, sec) ->
    if (pri? and sec?) then (pri or sec) else sec


  pinboard: ->
    new (require 'node-pinboard')(process.env.PINBOARD_TOKEN)


  respond: (data, format, template='result') ->
    out = switch format
      when 'color'
        chalk = (require 'chalk')
        data = data.posts if data.posts?
        text = '\n\n'

        render = (data, value) ->
          switch template
            when 'bookmark'
              """
              #{chalk.bold.white data.description}
              #{chalk.yellow data.tags or '--'}
              #{chalk.dim.gray data.href}\n\n
              """

            when 'date' then "#{chalk.bold.white data}: #{value}\n"
            when 'error' then chalk.bold.red(data)
            else chalk.bold.green(data[template])

        if Array.isArray(data)
          text += render(item) for item in data

        else if data.dates?
          data = data.dates
          text += render(i, data[i]) for i in Object.keys(data)

        else text = render(data)

        if chalk.supportsColor then text else chalk.stripColor(text)

      when 'json' then (JSON.stringify data)

    isError = (template is 'error')
    if isError then (console.error out) else (console.log out)
    process.exit isError


  verify: ->
    {notEqual} = (require 'assert')
    (require 'node-env-file')("#{__dirname}/.env")

    try
      notEqual process.env.PINBOARD_TOKEN, 'user:XXXXXXXXXXXXXXXXXXXX'

    catch
      console.error 'PINBOARD_TOKEN env variable not found.'
      process.exit yes


  yesno: (what) ->
    return undefined unless what?
    if (what is yes) then 'yes' else 'no'
