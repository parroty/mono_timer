window.countdownTimerId = null
window.lastFocus = true
window.lastUpdated = null

$ ->
  updateTimerDisplay(window.remainingSeconds)

  if isCountingDown == "true"
    countdownTimerId = setInterval ->
      if window.remainingSeconds > 0
        window.remainingSeconds -= 1
      else
        clearInterval(countdownTimerId)
        refreshScreen()

      updateTimerDisplay(window.remainingSeconds)

      if isFocusGained() == true || isResumed() == true
        synchronizeTimer()

      window.lastFocus   = hasFocus()
      window.lastUpdated = currentTime()
    , 1000

isFocusGained = ->
  hasFocus() == true && window.lastFocus == false

isResumed = ->
  currentTime() - window.lastUpdated > 5000

currentTime = ->
  new Date().getTime()

hasFocus = ->
  window.document.hasFocus()

synchronizeTimer = ->
  $.ajax
    async: true
    type: "GET"
    url: "/timers/" + timerId
    success: (data, status, xhr) ->
      window.remainingSeconds = parseInt(data.remaining_seconds)
      refreshScreen() if window.remainingSeconds <= 0

refreshScreen = ->
  location.reload()

updateTimerDisplay = (remainingSeconds) ->
  $("#timer-time").text(convertSecondsToTimer(remainingSeconds))

convertSecondsToTimer = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return addZeroPadding(minutes) + ":" + addZeroPadding(seconds)

addZeroPadding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);
