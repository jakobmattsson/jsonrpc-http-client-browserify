mocha.setup({ ui: 'bdd', timeout: 10000, ignoreLeaks: true })

config = require('lib/config').config
client = require 'lib/client'

assert = (expr, msg) -> throw new Error(msg || 'failed') if !expr

describe 'construct', ->

  it "should return an error if given an invalid endpoint", (done) ->
    c = client.construct({ endpoint: 'foobar', timeout: 2000 })
    c 'authPassword', {
      app: 'locke'
      email: config.username
      password: 'apa'
      secondsToLive: 10
    }, (err, data) ->
      assert(err && err.constructor == Error, "should be error")
      done()

  it "should return a textual error if an error is generated on the server", (done) ->
    c = client.construct({ endpoint: config.locke })
    c 'authPassword', {
      app: 'locke'
      email: config.username
      password: 'apa'
      secondsToLive: 10
    }, (err, data) ->
      assert(err && err.constructor == Error, "should be error")
      assert(err.message, 'Incorrect password')
      done()

  it "should return some data if given a valid endpoint", (done) ->
    c = client.construct({ endpoint: config.locke })
    c 'authPassword', {
      app: 'locke'
      email: config.username
      password: config.password
      secondsToLive: 10
    }, (err, data) ->
      assert(!err?, "should not be an error")
      assert(_.isEqual(Object.keys(data), ['token', 'validated']), "should get some data back")
      done()

  it "should return some data if given a valid endpoint and parameters in an array", (done) ->
    c = client.construct({ endpoint: config.locke })
    c 'authPassword', {
      app: 'locke'
      email: config.username
      password: config.password
      secondsToLive: 10
    }, (err, data) ->
      assert(!err?, "should not be an error")
      assert(_.isEqual(Object.keys(data), ['token', 'validated']), "should get some data back")
      done()
