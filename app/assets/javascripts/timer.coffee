# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  updateTimer(remainingSeconds)

  if isTimerActive == 'true'
    timerId = setInterval ->
      remainingSeconds -= 1
      updateTimer(remainingSeconds)
      if remainingSeconds == 0
        clearInterval(timerId)
    , 1000

updateTimer = (remainingSeconds) ->
  $("#timer-time").text(secondsToTimerString(remainingSeconds))

secondsToTimerString = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return zeroPadding(minutes) + ":" + zeroPadding(seconds)

zeroPadding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);
