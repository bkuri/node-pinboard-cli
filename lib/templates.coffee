'use strict'

render = (what) ->
  callback = (val...) ->
    chalk = require('chalk')

    text = switch what
      when 'bookmarks'
        """
        #{ chalk.bold.white val[0].description }
        #{ chalk.yellow val[0].tags or '--' }
        #{ chalk.dim.gray val[0].href }\n\n
        """

      when 'dates', 'suggestions', 'tags'
        "#{ chalk.bold.white val[0] }: #{ val[1] }\n"

      when 'error'
        chalk.bold.red(val[0])

      when 'note'
        "\n#{ chalk.bold.white val[0].title }\n#{ val[0].text }"

      when 'notes'
        "#{ chalk.bold.white val[0]}: [#{ chalk.gray val[1] }] #{ val[2] }\n"

      when 'result'
        chalk.bold.green val[0]

      else
        chalk.bold.green val[0][what]

    if chalk.supportsColor then text
    else chalk.stripColor(text)
    return

  return callback

module.exports = { render }
