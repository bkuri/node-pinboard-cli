'use strict'

###
This is basically node-pinboard + coffeescript.
I used the version from github because the npm module seems to be out of date.
###

{ get } = require('request')
{ isFunction, merge } = require('lodash')
URL_API = 'https://api.pinboard.in/v1'

method = (endpoint, singleOption) ->
  callback = (opts, cb) ->
    if singleOption?
      optsObj = {}
      optsObj[singleOption] = opts
      opts = optsObj

    else if !cb? and isFunction(opts)
      cb = opts
      opts = {}

    else if opts.tags?
      opts.tag = opts.tags

    params =
      json: yes
      qs: merge(auth_token: @token, format: 'json', opts)
      uri: "#{ URL_API }/#{ endpoint }"

    get params, (err, res, body) ->
      if err?
        return console.error(err)

      else if cb?
        cb body
        return

      else
        return body

    return callback

class Pinboard
  constructor: (@token) ->
    return

  # options: url (req), description (title)(req), extended, tags, dt (datetime), replace (yes/no), shared (yes/no), toread (yes/no)
  # API docs: "Add a bookmark."
  add: method('posts/add')

  # options: tag, start, results, fromdt, todt, meta
  # API docs: "Returns all bookmarks in the user's account."
  all: method('posts/all')

  # API docs: "Returns the user's API token (for making API calls without a password)"
  api_token: method('user/api_token')

  # Filter by up to three tags.
  # API docs: "Returns a list of dates with the number of posts at each date."
  dates: method('posts/dates')

  # API docs: "Delete a bookmark."
  delete: method('posts/delete', 'url')

  # API docs: "Delete an existing tag."
  delTag: method('tags/delete', 'tag')

  # options: url (req), description (title)(req), extended, tags, dt (datetime), replace (yes/no), shared (yes/no), toread (yes/no)
  # API docs: "Returns one or more posts on a single day matching the arguments. If no date or url is given, date of most recent bookmark will be used."
  get: method('posts/get')

  # API docs: "Returns an individual user note. The hash property is a 20 character long sha1 hash of the note text."
  getNote: (id, cb) ->
    method("notes/#{ id }").bind(this)({}, cb)
    return

  # "Returns a full list of the user's tags along with the number of times they were used."
  getTags: method('tags/get')

  # API docs: "Returns a list of the user's notes"
  listNotes: method('notes/list')

  # Up to three tags.
  # API docs: "Returns a list of the user's most recent posts, filtered by tag."
  recent: method('posts/recent')

  # options: old (req), new (req)
  # API docs: "Rename an tag, or fold it in to an existing tag"
  renameTag: method('tags/rename')

  # API docs: "Returns a list of popular tags and recommended tags for a given URL. Popular tags are tags used site-wide for the url; recommended tags are drawn from the user's own tags."
  suggest: method('posts/suggest', 'url')

  # API docs: "Returns the most recent time a bookmark was added, updated or deleted."
  update: method('posts/update')

  # API docs: "Returns the user's secret RSS key (for viewing private feeds)"
  userSecret: method('user/secret')

module.exports = Pinboard
