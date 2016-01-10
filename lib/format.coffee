'use strict'


module.exports =
  format: (what) ->
    return (data, type='result') ->
      result = switch what

        when 'color'
          data = data.notes if data.notes?
          data = data.posts if data.posts?
          render = (require './templates').render(type)
          text = '\n\n'

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

          text


        when 'json'
          JSON.stringify(data)


      isError = (type is 'error')

      if isError then console.error(result)
      else console.log(result)
      process.exit isError
