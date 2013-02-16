reqwest = require 'reqwest'

argsToQueryString = (args) ->
  Object.keys(args).map (key) ->
    encodeURIComponent(key) + '=' + encodeURIComponent(args[key])
  .join('&')

exports.construct = ({ endpoint, timeout }) ->
  id = 1
  timeout ?= 5000

  (method, params, callback) ->
    timedout = false

    setTimeout ->
      return if timedout
      timedout = true
      callback(new Error('Timeout'))
    , timeout

    reqwest
      type: 'jsonp'
      method: 'get'
      url: endpoint + "/#{method}?" + argsToQueryString(params)
      success: (data) ->
        return if timedout
        return callback(new Error(data.error?.data)) if data.error
        callback(null, data.result)
      error: ->
        return if timedout
        callback(new Error('error'))
