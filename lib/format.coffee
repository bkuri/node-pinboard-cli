'use strict'


module.exports =
  format: (what) ->
    return (data, type='result') ->
      result = switch what

        when 'color'
          chalk = (require 'chalk')
          data = data.posts if data.posts?
          data = data.notes if data.notes?
          text = '\n\n'

          render = (val...) ->
            switch type

              when 'bookmarks'
                """
                #{chalk.bold.white val[0].description}
                #{chalk.yellow val[0].tags or '--'}
                #{chalk.dim.gray val[0].href}\n\n
                """

              when 'dates', 'tags'
                "#{chalk.bold.white val[0]}: #{val[0]}\n"

              when 'error'
                chalk.bold.red(val[0])

              when 'note'
                "\n#{chalk.bold.white val[0].title}\n#{val[0].text}"

              when 'notes'
                "#{chalk.bold.white val[0]}: [#{chalk.gray val[1]}] #{val[2]}\n"

              else
                chalk.bold.green(val[0][type])


          if Array.isArray(data)
            text += switch type

              when 'notes'
                render(n.updated_at, n.id, n.title) for n in data

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
