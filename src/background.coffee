window.peek = (promise) ->
  ret = undefined
  if promise.state() is "resolved"
    promise.then( (resolvedValue) ->
      ret = resolvedValue
      )
    return ret
  else
    throw "Not resolved!"

window.promisfy = (async, thisObj, args...) ->
  dfd = $.Deferred()
  args.push (callbackArgs...) ->
    dfd.resolve.apply dfd, callbackArgs
  async.apply thisObj, args
  dfd


window.BG =
  updateData: ->
    @getLastFocusedWindow().then( (chromeWindow)->


    )
    chrome.windows.getLastFocused (chromeWindow) ->
      return unless window?

# returns a promise for the last focused window object
  getLastFocusedWindow: ->
    promisify chrome.windows.getLastFocused, @

# returns a promsie for current tab
  getCurrentTab: ->
    promisify chrome.windows.getLastFocused, @,

  getDomainFromTab: (tab)->
    tab.url








  # setInterval updateData, 3000





###
chrome.extension.onRequest.addListener (request, sender, sendResponse)->
  switch request.message
    when "getTabs"
      chrome.tabs.query currentWindow:true, (tabs)->
        sendResponse(tabs:tabs)
      break
    when "switchTab"
      chrome.tabs.update(request.target.id, selected:true)
      sendResponse({})
      break
    when "requestConfig"
      chrome.storage.sync.get "config", (items)->
        sendResponse(config:items.config)
      break
    else
      sendResponse({})
###
