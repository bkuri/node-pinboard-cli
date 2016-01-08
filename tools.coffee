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
      .option '-f, --format <fmt>', 'output format', /^(color|json)$/i, 'color'
      .option '-v, --verbose', 'display all errors'


  pinboard: ->
    new (require 'node-pinboard')(process.env.PINBOARD_TOKEN)


  respond: (data, template='result') ->
    out = switch process.env.PINBOARD_FORMAT
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
      console.error 'PINBOARD_TOKEN env variable not found. Enter `pinboard help` for more information.'
      process.exit yes
