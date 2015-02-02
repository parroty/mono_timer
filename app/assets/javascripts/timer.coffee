# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  timerId = setInterval ->
    timerCount -= 1
    $("#timer-time").text(seconds_to_timer_str(timerCount))
    if timerCount == 0
      clearInterval(timerId)
  , 1000

seconds_to_timer_str = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return padding(minutes) + ":" + padding(seconds)

padding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);
