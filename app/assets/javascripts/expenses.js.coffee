init_expense_list_toggle_handler = ($) ->
  $('.expenses, .bills').delegate('.expenses-sub', 'click', (e) ->
    self = $(this)
    if self.hasClass('toggled')
      self.removeClass('toggled')
    else
      $('.expenses .expenses-sub').removeClass('toggled')
      self.addClass('toggled')
  )

init_expense_remote_form = ($) ->
  $('.expense_form[data-remote=true]').each (e) ->
    self = $(this)
    added = self.find('+ .expenses-added')

    submit = self.find('input[type=submit]')
    orig_submit_value = submit.val()

    self.bind 'ajax:send', ->
      submit.prop('disabled', true)

    self.bind 'ajax:complete', ->
      submit.val(orig_submit_value)
      submit.prop('disabled', false)

    self.bind 'ajax:success', (e, data, status, xhr) ->
      if data.success
        added.prepend data.html
        self.find('input[type=text]').not('.picker__input').val('')
        self.find('.error_explanation').remove()
      else
        error = self.find('.error_explanation')
        if error.length == 0
          error = $('<div>')
          self.append(error)

        received_error = $.parseHTML(data.html)[0].querySelector('.error_explanation')
        error.attr('class', received_error.className)
        new_error = received_error.innerHTML

        error.html(new_error)

init = ($) ->
  init_expense_list_toggle_handler($)
  init_expense_remote_form($)

jQuery(($) ->
  $('document').on('page:change', -> init($))
  init($)
)
