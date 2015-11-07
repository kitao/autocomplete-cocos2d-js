fs = require 'fs'
path = require 'path'

module.exports =
  selector: '.source.js, .source.coffee'
  suggestionPriority: -1
  filterSuggestions: true

  getSuggestions: ({prefix}) ->
    return [] unless prefix.length >= 3
    ({type: obj.type, text: obj.text} for obj in @completions)

  loadCompletions: ->
    @completions = []
    fs.readFile(
      path.resolve(__dirname, '..', 'completions.json'),
      (err, data) => @completions = JSON.parse(data) unless err?)
