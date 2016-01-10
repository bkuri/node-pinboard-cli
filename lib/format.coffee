'use strict'


module.exports =
  format: (what) ->
    return (data, type='result') ->
      result = switch what

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
            text += switch type

              when 'tags'
                category = ['popular', 'recommended']
                render(c, data[i][c].join ', ') for c, i in category

              else
                render(item) for item in data

          else if data.dates?
            text += render(k, data.dates[k]) for k in Object.keys(data.dates)

          else
            text = render(data)


          if chalk.supportsColor then text
          else chalk.stripColor(text)


        when 'json'
          JSON.stringify(data)


      isError = (type is 'error')

      if isError then console.error(result)
      else console.log(result)
      process.exit isError
