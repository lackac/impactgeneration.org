winHeight = $(window).height()
navHeight = $('nav').height()

$('section.slide').each ->
  $(this).outerHeight(winHeight) if $(this).outerHeight() < winHeight

$('.top-bar h1 a, [data-anchors] a, .scroller').click (e) ->
  return unless $(this).attr('href').indexOf('#') == 0
  e.preventDefault()
  target = $(this).attr('href')
  position = $(target).offset().top - navHeight
  $('html, body').animate({scrollTop: position}, 1200, 'easeOutExpo')
