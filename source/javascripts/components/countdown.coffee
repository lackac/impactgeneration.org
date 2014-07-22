$('[data-countdown-to]').each ->
  $el = $(this)
  target = moment($el.data('countdown-to'))

  setInterval ->
    diff = target.diff()

    if diff < 0
      if overText = $el.data('countdown-over')
        dots = -Math.ceil(diff / 500) % 4
        $el.text(overText + '...'.substr(0, dots)).addClass('over')
        return
      else
        diff = 0

    diff = moment(diff).utc()
    days = diff.dayOfYear() - 1
    days = if days < 10 then "0#{days}" else days

    $el.text "#{days}.#{moment(diff).format('HH:mm:ss')}"
  , 500
