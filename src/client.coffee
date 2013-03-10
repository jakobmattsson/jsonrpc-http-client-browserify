reqwest = require 'reqwest'

argsToQueryString = (args) ->
  Object.keys(args).map (key) ->
    encodeURIComponent(key) + '=' + encodeURIComponent(args[key])
  .join('&')

exports.construct = ({ endpoint, timeout }) ->
  timeout ?= 5000

  (method, params, callback) ->

    onceCallback = do ->
      called = false
      (args...) ->
        return if called
        called = true
        callback(args...)

    setTimeout ->
      onceCallback(new Error('Timeout'))
    , timeout

    reqwest
      type: 'jsonp'
      method: 'get'
      url: endpoint + "/#{method}?" + argsToQueryString(params)
      success: (data) ->
        return onceCallback(new Error(data.error?.data)) if data.error
        onceCallback(null, data.result)
      error: ->
        onceCallback(new Error('error'))
