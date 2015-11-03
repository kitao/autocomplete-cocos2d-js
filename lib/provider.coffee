module.exports =
  provider =
    selector: '.source.js, .source.coffee'

  getSuggestions: (request) ->
    test =
      text: 'autocomplete_sample_keyword'
      type: 'function'
    [test]
