window.countdownTimerId = null
window.hasFocus = true

$ ->
  updateTimerDisplay(window.remainingSeconds)

  if isCountingDown == 'true'
    countdownTimerId = setInterval ->
      if window.remainingSeconds > 0
        window.remainingSeconds -= 1
      else
        clearInterval(countdownTimerId)

      updateTimerDisplay(window.remainingSeconds)

      synchronizeTimer() if isFocusGained() == true
      window.hasFocus = window.document.hasFocus()
    , 1000

isFocusGained = ->
  window.document.hasFocus() == true && window.hasFocus == false

synchronizeTimer = ->
  $.ajax
    async: true
    type: 'GET'
    url: "/timers/" + timerId
    success: (data, status, xhr) ->
      window.remainingSeconds = parseInt(data.remaining_seconds)

updateTimerDisplay = (remainingSeconds) ->
  $("#timer-time").text(convertSecondsToTimer(remainingSeconds))

convertSecondsToTimer = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return addZeroPadding(minutes) + ":" + addZeroPadding(seconds)

addZeroPadding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);
