window.peek = (promise) ->
  ret = undefined
  if promise.state() is "resolved"
    promise.then( (resolvedValue) ->
      ret = resolvedValue
      )
    return ret
  else
    throw "Not resolved!"

window.resolvify = (promiseOrValue) ->
  if typeof promiseOrValue.then == "function"
    window.peek promiseOrValue
  else
    promiseOrValue




window.promisify = (async, thisObj, args...) ->
  dfd = $.Deferred()
  args.push (callbackArgs...) ->
    dfd.resolve.apply dfd, callbackArgs
  async.apply thisObj, args
  dfd


window.BG =
  parseUrl: (url) ->
    regex = /(\w+):\/\/([^/]*)\/(.*)/
    matches = url.match regex
    # url: matches[0]
    # protocol: matches[1]
    domain: matches[2]
    page: matches[3]

  preparePayload: (url, title) ->
    payload = @parseUrl(url)
    payload.title = title
    payload
    time_spent: @getTimeSpent()

  track: (tab)->
    mixpanel.track "tab_focused", @preparePayload(tab.url, tab.title)

  updateData: ->
    @getCurrentTab().then( (tab) =>
      @track(tab)
    )

# returns a promise for the last focused window object
  getTimeSpent: ->
    @UPDATE_INTERVAL / 1000

  getLastFocusedWindow: ->
    promisify chrome.windows.getLastFocused, @

# returns a promise for active tab from current window
  getCurrentTabFromWindow: (chromeWindow)->
    pTabs = promisify chrome.tabs.query, @,
      windowId: chromeWindow.windowId
      # currentWindow: true,
      active: true
    pTabs.then (chromeTabs) ->
      chromeTabs[0]

# returns a promise for current tab
  getCurrentTab: ->
    @getLastFocusedWindow().then( (chromeWindow) =>
      @getCurrentTabFromWindow(chromeWindow)
    )

  getDomainFromTab: (tab)->
    tab.url

# Update interval in milliseconds
BG.UPDATE_INTERVAL = 4000


setInterval (-> BG.updateData()), BG.UPDATE_INTERVAL

chrome.windows.onFocusChanged.addListener (windowId) ->
  console.log "windowId #{windowId}"




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
