'use strict'


module.exports =
  format: (what) ->
    return (data, type='result') ->
      result = switch what

        when 'color'
          data = switch
            when data.dates? then data.dates
            when data.notes? then data.notes
            when data.posts? then data.posts
            when data.result? then data.result
            else data

          render = (require './templates').render(type)
          text = '\n\n'

          switch type
            when 'dates', 'tags'
              text += render(k, data[k]) for k in Object.keys(data)

            when 'notes'
              text += render(n.updated_at, n.id, n.title) for n in data

            when 'suggestions'
              category = ['popular', 'recommended']
              text += render(c, data[i][c].join ', ') for c, i in category

            when Array.isArray(data)
              text += render(item) for item in data

            else
              text = render(data)

          text.split(',').join('')


        when 'json'
          JSON.stringify(data)


      isError = (type is 'error')

      if isError then console.error(result)
      else console.log(result)
      process.exit isError
