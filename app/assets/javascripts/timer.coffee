# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

timerId = null

window.stopTimer = (id) ->
  clearInterval(timerId)
  $.ajax "/timer/" + id + "/stop", type: 'POST'

$ ->
  updateTimer(remainingSeconds)

  if isTimerActive == 'true'
    timerId = setInterval ->
      if remainingSeconds > 0
        remainingSeconds -= 1
      else
        clearInterval(timerId)

      updateTimer(remainingSeconds)
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
