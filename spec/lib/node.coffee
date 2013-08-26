jscov = require 'jscov'
jsdom = require 'jsdom'
xmlhttprequest = require 'xmlhttprequest'

global = do -> this


# Extending require-functions
global.reqSrc = (path) -> require jscov.cover("../..", "src", path)
global.reqSpec = (path) -> require "../../spec/#{path}"


# Mocking XMLHttpRequest
global.XMLHttpRequest = xmlhttprequest.XMLHttpRequest
global.XMLHttpRequest::withCredentials = true


# Mocking the DOM
doc = jsdom.jsdom("<html><head><script></script></head><body></body></html>", null, {})
global.window = doc.parentWindow
global.document = global.window.document
global.navigator = global.window.navigator