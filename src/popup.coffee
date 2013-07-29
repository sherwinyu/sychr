defaultKey = {
  keyCode: 75 # k
  ctrlKey: true
  altKey: false
  metaKey: false
  shiftKey: false
}

#$("head").prepend('<script type="text/javascript">(function(c,a){window.mixpanel=a;var b,d,h,e;b=c.createElement("script");b.type="text/javascript";b.async=!0;
# b.src=("https:")+\'//cdn.mxpnl.com/libs/mixpanel-2.1.min.js\';d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f? g=a[f]=[]:f="mixpanel";g.people=g.people||[];h="disable track track_pageview track_links track_forms register register_once unregister identify name_tag set_config people.identify people.set people.increment".split(" ");for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.1})(document,window.mixpanel||[]);</script>');
$ ->
  $('#manual').click (e)->
    mixpanel.track "wagawaga", count: 1
    console.log 'waga waga'

  chrome.storage.sync.get "config", (items)->
    if items.config?
      $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(items.config))
    else
      chrome.storage.sync.set config:defaultKey, ->
        $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(defaultKey))

  $('input#tabswitcher-settings-hotkey-input').keydown (event)->
    unless event.keyCode == 27 # esc
      chrome.storage.sync.set config:extractConfigFromEvent(event), -> null
    else
      window.close()
      return

    $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(event))

    false

convertToReadableHotkey = (event)->
  "#{extractModifierFromEvent(event)}+ #{String.fromCharCode(event.keyCode)}"

extractConfigFromEvent = (event)->
  keyCode: event.keyCode
  ctrlKey: event.ctrlKey
  altKey:  event.altKey
  metaKey: event.metaKey
  shiftKey: event.shiftKey

extractModifierFromEvent = (event)->
  modifier = ""

  if event.ctrlKey
    modifier += 'Ctrl '

  if event.altKey
    modifier += 'Alt '

  if event.metaKey
    modifier += 'Cmd '

  if event.shiftKey
    modifier += 'Shift '

  modifier

