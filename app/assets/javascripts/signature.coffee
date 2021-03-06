# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# extend existing domains
Mailcheck.defaultDomains.push(
  'dds.nl', 'deds.nl', 'hotmail.com', 'gmail.com', 'live.nl', 'home.nl',
  'hetnet.nl', 'planet.nl', 'ziggo.nl', 'xs4all.nl', 'chello.nl', 'upcmail.nl',
  'casema.nl', 'kpnmail.nl', 'yahoo.com', 'kpnplanet.nl', 'zonnet.nl',
  'quicknet.nl', 'hotmail.nl', 'msn.com', 'online.nl', 'zeelandnet.nl',
  'telfort.nl', 'versatel.nl', 'tiscali.nl', 'tele2.nl', 'outlook.com',
  'me.com', 'wanadoo.nl', 'hccnet.nl', 'wxs.nl', 'telenet.be')
# extend existing SLDs
# Mailcheck.defaultSecondLevelDomains.push('domain', 'yetanotherdomain')
Mailcheck.defaultTopLevelDomains.push('nl', 'be', 'eu', 'de')

suggested = (element, sugestion) ->
  #console.log(sugestion)
  tip_id = '#didyoumean_' + element[0].id
  #console.log(tip_id)
  sugestion_id = '#suggest_' + element[0].id
  #console.log(sugestion_id)
  sugElement = $(sugestion_id)
  sugElement.text sugestion.full
  tipElement = $(tip_id)
  tipElement.show()

empty = (elements, suggestion) ->
  tip_id = '#didyoumean_' + elements[0].id
  sugestion_id = '#suggest_' + elements[0].id
  sugElement = $(sugestion_id)
  $(sugestion_id).text ""
  tipElement = $(tip_id)
  tipElement.hide()

delay = (
  timer = 0
  (callback, ms) ->
    clearTimeout(timer)
    setTimeout(callback, ms)
  )


# while typing email form check the email field with a little delay
$ ->
  $('[id$=_email]').keyup(->
    input = this
    delay(->
      $(input).mailcheck suggested: suggested, empty: empty
    , 400))


# on focusing to the next form check the mail field
# and do a suggestion
$ ->
  $('[id$=_email]').bind 'blur', ->
    $(this).mailcheck suggested: suggested, empty: empty


# replace content of email form when clicked.
# and remove the sugestion
$ ->
  $('[id^=didyoumean_]').on "click", ->
    #console.log('yes')
    # find email element
    id = $(this)[0].id
    input_id = id.split('didyoumean_')[1]
    element = $('#' + input_id)
    sugestion_id = '#suggest_' + input_id
    element.val $(sugestion_id).html()
    #console.log(element)
    # empty suggestion box
    $(sugestion_id).html ""
    # hide the tip box
    tip_id = '#didyoumean_' + input_id
    #console.log(tip_id)
    tipElement = $(tip_id)
    tipElement.hide()



# confirmation error handling

#  ///////
#  // CODE FOR CONFIRMING SIGNATURE PAGE
#  ///////

$ ->

  $('.edit_signature input').bind('keyup', ->
    if $(this).hasClass('error')
      $(this).removeClass('error')
  )

  $('.edit_signature').submit( ->
    nameRegex = /^\w+\s+\w+[\w+\s+]{0,}$/
    $nameField = $('#signature_person_name')
    $errorsBlock = $('#confirm_form_errors')
    # default result
    result = true
    #//clear erors block
    #//$errorsBlock.html('')
    #if !$nameField.val().match(nameRegex)
    #  $nameField.addClass('error')
    #  error_name = window.wrong_name_error || 'Name and Surname'
    #  #//$errorsBlock.append(error_name)
    #  #//$errorsBlock.append('Please enter correct Name and Surname.<br>')
    #  result = false
    return result

  ).on('ajax:success', (e, data, status, xhr) ->
    $('#confirm_success').show()
    $('#confirm_error_messages').html('')
    $('#confirm_errors').hide()
    $('.edit_signature').clear_form_errors()
  ).on('ajax:error', (e, data, status, xhr) ->
    $('#confirm_success').hide()
    $('.edit_signature').render_form_errors('signature', data.responseJSON)
    $('#confirm_errors').show()
  )

  # pledge success note
  $('.edit_pledge, .new_pledge').on('ajax:success', (e, data, status, xhr) ->
    $('.pledge_thanks').show()
    $('.edit_pledge, .new_pledge').clear_form_errors()
    $('.pledge_error').hide()
  )

  $('.edit_pledge, .new_pledge').on('ajax:error', (e, data, status, xhr) ->
    $('.pledge_thanks').hide()
    $('.edit_pledge, .new_pledge').render_form_errors('pledge', data.responseJSON)
    $('.pledge_error').show()
  )

  # sign email success..
  $('form#new_invite_form').on('ajax:success', (e, data, status, xhr) ->
    $('#success_share_email').show()
    $('#fail_share_email').hide()
    $('#input_share_email').val("")
    $('#input_share_email').attr("placeholder", "Thank you! Please invite more")
    #$('#feedback').html('Well done!')
  )

  # sign email fail
  $('form#new_invite_form').on('ajax:error', (e, data, status, xhr) ->
    $('#success_share_email').hide()
    $('#fail_share_email').show()
    $('#input_share_email').val("")
    $('#input_share_email').attr("placeholder", "Failed! Try again")
    #$('#feedback').html('failed')
  )


window.debugthis = []

# obligatory fields show green
$.fn.render_form_obligations = (model_name, fields) ->

  form = this
  fields = window.check_fields

  if not fields
    return

  $.each(fields, (i, field) ->
    input = form.find('input, select, textarea').filter(->
      name = $(this).attr('name')
      if name
        name.match(new RegExp(model_name + '\\[' + field + '\\]'))
    )
    input.addClass('is_obligated')
    )

$ ->
  $('.edit_signature').render_form_obligations('signature')

# add error class and text to each form field
$.fn.render_form_errors = (model_name, errors) ->
  form = this

  this.clear_form_errors()

  $.each(errors, (field, messages) ->
    input = form.find('input, select, textarea').filter(->
      name = $(this).attr('name')
      if name
        name.match(new RegExp(model_name + '\\[' + field + '\\]'))
    )
    input.addClass('has_error')
    input.parent().append('<div class="has_error_help">' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</div>')
  )

# clear all error related classes and fields
$.fn.clear_form_errors = () ->
  this.find('.has_error').removeClass('has_error')
  this.find('div.has_error_help').remove()



