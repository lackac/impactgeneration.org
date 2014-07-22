$('form.contact select[name=category]').change (e) ->
  if $(this).val() is 'visas'
    $('form.contact .for-visas').show()
    allowSlideToGrow()
  else
    $('form.contact .for-visas').hide()

$('form.contact').submit (e) ->
  e.preventDefault()

  $form = $(this)
  $submit = $form.find('input[type=submit]')

  if $form.find('select[name=category]').val() isnt 'visas'
    # clear visas related fields
    $form.find('.for-visas').find('select, input, textarea').val('')

  data = $form.serialize()

  $form.find('.alert-box').remove()
  $form.find('small.error').remove()
  $submit.addClass('disabled').attr('disabled', 'disabled')
  $form.find('select').before(loadingBox())

  $.post $form.attr('action'), $form.serialize(), (data) ->
    $submit.removeClass('disabled').attr('disabled', null)
    $form.find('.alert-box').remove()

    if data.ok
      $form.find('select[name=category]').before(successBox(data.ok))
      $form.find('select, input[type=email], input[type=text], textarea').val('')
    else
      for field, error of data
        $form.find("[name=#{field}]").after("<small class=\"error\">#{error}</small>")
  , "json"

loadingBox = ->
  """
  <div data-alert class="alert-box info radius">
    Posting question...
  </div>
  """

successBox = (message) ->
  """
  <div data-alert class="alert-box success radius">
    #{message}
    <a href="#" class="close">&times;</a>
  </div>
  """

allowSlideToGrow = ->
  return if allowSlideToGrow.haveBeenCalled
  allowSlideToGrow.haveBeenCalled = true

  height = $('#contact').outerHeight()
  $('#contact').css
    height: 'auto'
    'min-height': "#{height}px"
