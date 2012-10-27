$ = jQuery

App.general = ->

  # closing flash messages

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')

  # bootstrap tooltips

  $('.item_controls a, button').tooltip()

  $('a.tour').tooltip
    placement: 'left'

  $('input[type="text"]')
    .tooltip
      placement: 'right'
      trigger: 'focus'
      title: ->
        if $(@).val()
          console.log $(@).attr('data-original-title')

  # delete confirmation

  $('.item_controls').find('.delete').fancybox
    wrapCSS:  'confirm'
    width:    250
    type:     'ajax'

  # notification

  $('.flash.notification').find('form').on 'submit', (event) ->
    event.preventDefault()

    $form = $(@)

    $.ajax
      type: $form.attr('method')
      url: $form.attr('action')
      data: $form.serialize()

    $form.closest('.flash')
      .fadeOut 'fast', -> $(@).remove()
