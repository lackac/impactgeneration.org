$('form.contact').submit (e) ->
  e.preventDefault()

  $form = $(this)
  $submit = $form.find('input[type=submit]')

  data = $form.serialize()

  $form.find('.alert-box').remove()
  $form.find('small.error').remove()
  $submit.addClass('disabled').attr('disabled', 'disabled')
  $form.find('select').before(loadingBox())

  $.post $form.attr('action'), $form.serialize(), (data) ->
    $submit.removeClass('disabled').attr('disabled', null)
    $form.find('.alert-box').remove()

    if data.ok
      $form.find('input[type=email]').before(successBox(data.ok))
      $form.find('input[type=email], textarea').val('')
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
