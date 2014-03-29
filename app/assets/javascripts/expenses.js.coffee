init = ($) ->
  $('.expenses').delegate('.expenses-sub', 'click', (e) ->
    self = $(this)
    if self.hasClass('toggled')
      self.removeClass('toggled')
    else
      $('.expenses .expenses-sub').removeClass('toggled')
      self.addClass('toggled')
  )

jQuery(($) ->
  $('document').on('page:change', -> init($))
  init($)
)
