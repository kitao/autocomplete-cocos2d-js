fs = require 'fs'
path = require 'path'

module.exports =
  selector: '.source.js, .source.coffee'
  suggestionPriority: -1
  filterSuggestions: true

  loadCompletions: ->
    @completions = {class: [], property: [], method: []}
    fs.readFile(
      path.resolve(__dirname, '..', 'completions.json'),
      (err, data) => @completions = JSON.parse(data) unless err?)

  getSuggestions: ({prefix}) ->
    return [] if prefix.length < 3
    class_names = @makeSuggestions('class', prefix)
    property_names = @makeSuggestions('property', prefix)
    method_names = @makeSuggestions('method', prefix)
    class_names.concat(property_names, method_names)

  makeSuggestions: (type, prefix) ->
    ({type: type, text: name} for name in @completions[type])
