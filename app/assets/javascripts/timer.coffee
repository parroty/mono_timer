timerId = null

$ ->
  updateTimerDisplay(remainingSeconds)

  if isCountingDown == 'true'
    timerId = setInterval ->
      if remainingSeconds > 0
        remainingSeconds -= 1
      else
        clearInterval(timerId)

      updateTimerDisplay(remainingSeconds)
    , 1000

updateTimerDisplay = (remainingSeconds) ->
  $("#timer-time").text(convertSecondsToTimer(remainingSeconds))

convertSecondsToTimer = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return addZeroPadding(minutes) + ":" + addZeroPadding(seconds)

addZeroPadding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);
