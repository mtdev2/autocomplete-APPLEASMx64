fs = require 'fs'
path = require 'path'
fuzzaldrin = require('fuzzaldrin')

module.exports =
  selector: '.source.asm'
  inclusionPriority: 1
  excludeLowerPriority: true

  wordRegex: /#?(?:\b64: )?\b\w+$/
  properties: {}
  keys: []

  getSuggestions: ({editor, bufferPosition}) ->
      prefix = @getPrefix(editor, bufferPosition)
      return [] unless prefix?.length >= 2
      return @getAsmSuggestions(prefix)

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''

  loadProperties: ->
      fs.readFile path.resolve(__dirname, '..', 'properties.json'), (error, content) =>
        return if error

        @properties = JSON.parse(content)
        @keys = Object.keys(@properties)

  getAsmSuggestions: (prefix) ->
    words = fuzzaldrin.filter(@keys, prefix.slice(1))
    for word in words
      {
        snippet: @properties[word].snippet
        displayText: word
        type: @properties[word].type
        rightLabel: @properties[word].rightLabel
        descirption: @properties[word].descirption
        replacementPrefix: prefix
      }
